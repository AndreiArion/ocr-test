 import org.bytedeco.javacpp.tesseract._
 import org.bytedeco.javacpp.lept._
 import org.bytedeco.javacpp._
 val api:TessBaseAPI=new TessBaseAPI()
 api.Init("/","eng")
 val image = pixRead("/javacpp-presets/tesseract/cppbuild/linux-x86_64/tesseract-3.04.01/testing/eurotext.tif")
 api.SetImage(image)
 api.GetUTF8Text().getString