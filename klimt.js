
function onFileSelected(event) {
	var selectedFile = event.target.files[0];
	var reader = new FileReader();

	var imgtag = new Image();
	imgtag.title = selectedFile.name;

	reader.onload = function(event) {
		imgtag.src = event.target.result;
		inst.setImg(event.target.result);
	};

	reader.readAsDataURL(selectedFile);
}