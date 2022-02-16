<script type="text/javascript">
  $("#micropost_image").bind("change", function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert(I18n.t("js.check_image.image_size"));
    }
  });
</script>
