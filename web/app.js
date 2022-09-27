
compressImageWeb();

async function compressImageWeb(url, radius) {
    var blob = await fetch(url).then(r => r.blob());
    var options = {
        maxSizeMB: 2,//right now max size is 200kb you can change
        maxWidthOrHeight: radius,
        useWebWorker: true
    }
    try {
        const compressedFile = await imageCompression(blob, options);
        return await blobToBase64(compressedFile)

    } catch (error) {
        console.log(error);
    }

    }

async function cropImageJS(URL, canvasWidth, canvasHeight){
var canvas = document.createElement('canvas');
canvas.width = canvasWidth;
canvas.height = canvasHeight;

var ctx = canvas.getContext('2d');
           var image = await downloadImage(URL)
           var imageWidth = image.width
           var imageHeight = image.height
          ctx.drawImage(image, Math.max(0, (imageWidth - canvasWidth) / 2),
                                                     Math.max(0, (imageHeight - canvasHeight) / 2),
                                                     canvasWidth, canvasHeight, 0, 0, canvasWidth, canvasHeight);

            return canvas.toDataURL()


}
async function downloadImage(URL){
    const img = new Image();
    img.crossOrigin="anonymous"
  img.src = URL;
  await img.decode();
  return img

}





    function blobToBase64(blob) {
      return new Promise((resolve, _) => {
        const reader = new FileReader();
        reader.onloadend = () => resolve(reader.result);
        reader.readAsDataURL(blob);
      });
    }
function addImageProcess(src){
  return new Promise((resolve, reject) => {
    let img = new Image()
    img.onload = () => resolve(img)
    img.onerror = reject
    img.src = src
  })
}

