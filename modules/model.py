import torch
from transformers import NougatProcessor, VisionEncoderDecoderModel
from PIL import Image

class ArabicOCR:
    def __init__(self) -> None:
        self.processor = NougatProcessor.from_pretrained("MohamedRashad/arabic-small-nougat")
        self.model = VisionEncoderDecoderModel.from_pretrained("MohamedRashad/arabic-small-nougat")
        self.device = "cuda" if torch.cuda.is_available() else "cpu"
        self.model.to(self.device)

        self.context_length = 2048


    def predict(self, img_path):
        # prepare PDF image for the model
        image = Image.open(img_path)
        pixel_values = self.processor(image, return_tensors="pt").pixel_values

        # generate transcription
        outputs = self.model.generate(
            pixel_values.to(self.device),
            min_length=1,
            max_new_tokens=self.context_length,
            bad_words_ids=[[self.processor.tokenizer.unk_token_id]],
        )

        page_sequence = self.processor.batch_decode(outputs, skip_special_tokens=True)[0]
        page_sequence = self.processor.post_process_generation(page_sequence, fix_markdown=False)
        return page_sequence
