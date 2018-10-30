  $(document).ready(function() {

    $('#normal_dt').DataTable({
      scrollY: "35vh",
      scrollCollapse: true,
      paging: false,
      autoWidth: true,
      responsive: true,
      retrieve: true,
      dom: 'Bfrtip',
      buttons: [
        {
        extend: 'print',
        }
      ]
    });

    $("#btnPrint").printPreview({
      obj2print:'#main'
    });

  });
