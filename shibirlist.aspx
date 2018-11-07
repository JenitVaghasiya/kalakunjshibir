<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="shibirlist.aspx.cs" Inherits="shibirlist" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <br />
    <div class="row">
        <div class="col-md-12">
            <div class="col-md-6">
                <h1>Person List</h1>
            </div>
            <div class="col-md-5" style="float: right; text-align: right;">
                <h1>Total Person(s):
                <label id="personTotal"></label>
                </h1>
            </div>
            <hr />
            <%--<div id="jsGrid"></div>--%>
            <table id="jqGrid"></table>
            <div id="jqGridPager"></div>
        </div>
    </div>
    <style>
        .ui-widget *, .ui-widget input, .ui-widget select, .ui-widget button {
            font-family: 'Helvetica Neue Light', 'Open Sans', Helvetica;
            font-size: 14px;
            font-weight: 300 !important;
        }

        .details-form-field input,
        .details-form-field select {
            width: 250px;
            float: right;
        }

        .details-form-field {
            margin: 30px 0;
        }

            .details-form-field:first-child {
                margin-top: 10px;
            }

            .details-form-field:last-child {
                margin-bottom: 10px;
            }

            .details-form-field button {
                display: block;
                width: 100px;
                margin: 0 auto;
            }

        input.error, select.error {
            border: 1px solid #ff9999;
            background: #ffeeee;
        }

        label.error {
            float: right;
            margin-right: 60px;
            font-size: .8em;
            color: #ff6666;
        }

        #detailsDialog {
            overflow: hidden !important;
        }
    </style>
    <script>
        $(function () {
            $.ajax({
                type: "POST",
                url: "shibirlist.aspx/GetAllPerson",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnSuccess,
                failure: function (response) {
                    alert(response.d);
                }
            });

            function OnSuccess(response) {
                $("#jqGrid").jsGrid({
                    height: "400px",
                    width: "100%",
                    filtering: true,
                    editing: true,
                    sorting: true,
                    paging: true,
                    autoload: true,

                    pageSize: 10,
                    pageButtonCount: 5,
                    deleteConfirm: function (item) {
                        return "The person \"" + item.Name + "\" will be removed. Are you sure?";
                    },
                    rowClick: function (args) {
                        showDetailsDialog("Edit", args.item);
                    },
                    controller: {
                        data: JSON.parse(response.d),
                        onRefreshed: function (args) {

                        },
                        loadData: function (filter) {

                            var filteredRow = $.grep(this.data, function (client) {
                                return (!filter.ReciptNo || client.ReciptNo === filter.ReciptNo)
                                    && (!filter.Name || (client.Name != "" && client.Name != null && client.Name.toLowerCase().indexOf(filter.Name.toLowerCase()) > -1))
                                    && (!filter.MobileNumber || (client.MobileNumber != "" && client.MobileNumber != null && client.MobileNumber.startsWith(filter.MobileNumber)))
                                    && (!filter.Address || client.Address.indexOf(filter.Address) > -1)
                                    && (!filter.StayDaysInShibir || client.StayDaysInShibir === filter.StayDaysInShibir)
                                    && (!filter.EntryIn2018 || client.EntryIn2018 === filter.EntryIn2018)
                                    && (!filter.IsPresentToday || client.IsPresentToday === filter.IsPresentToday);
                            });

                            $("#personTotal").text(filteredRow.length);
                            return filteredRow;
                        },
                        insertItem: function (item) {

                            $.ajax({
                                type: "POST",
                                url: "shibirlist.aspx/InsertData",
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                data: "{ data: " + JSON.stringify(item) + " }",
                                success: function (resp) {
                                    window.location.reload();
                                },
                            });
                        },

                        updateItem: function (item) {
                            $.ajax({
                                type: "POST",
                                url: "shibirlist.aspx/UpdateData",
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                data: "{ data: " + JSON.stringify(item) + " }",
                                success: function (resp) {
                                    window.location.reload();
                                },
                            });
                        },

                        deleteItem: function (item) {
                            $.ajax({
                                type: "POST",
                                url: "shibirlist.aspx/DeleteData",
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                data: "{ data: " + JSON.stringify(item) + " }",
                                success: function (resp) {
                                    window.location.reload();
                                },
                            });
                        },
                    },
                    fields: [
                        { name: "ReciptNo", type: "text", width: 60 },
                        { name: "EntryIn2018", type: "checkbox", width: 60, title: "Entry in 2018?" },
                        { name: "Name", type: "text", width: 200 },
                        { name: "MobileNumber", type: "text", width: 80 },
                        { name: "Address", type: "text", width: 180 },
                        { name: "WhatsAppNumber", type: "text", width: 100, visible: false },
                        {
                            name: "StayFromDate", type: "date", width: 90,
                            itemTemplate: function (value) {
                                return formatDate(new Date(value));
                            },
                            filtering: false
                        },
                        {
                            name: "StayToDate", type: "date", width: 90,
                            itemTemplate: function (value) {
                                return formatDate(new Date(value));
                            },
                            filtering: false
                        },
                        { name: "HowmanyTimesInShibir", type: "number", visible: false },
                        {
                            name: "StayDaysInShibir", type: "number", width: 60, title: "StayDays In Shibir"
                        },
                        {
                            name: "IsPresentToday", type: "checkbox", width: 60, title: "Today Present?", visible: false 
                        },
                        {
                            type: "control",
                            modeSwitchButton: false,
                            editButton: false,
                            headerTemplate: function () {
                                return $("<button>").attr("type", "button").text("Add")
                                    .on("click", function () {
                                        showDetailsDialog("Add", {});
                                    });
                            }
                        },

                        { name: "Gam", type: "text", visible: false },
                        { name: "Taluka", type: "text", visible: false },
                        { name: "Jillo", type: "text", visible: false },
                        { name: "Age", type: "number", visible: false },
                        { name: "Email", type: "text", visible: false },
                        { name: "AvailableAtKalakunjSabha", type: "checkbox", visible: false },
                        { name: "SabhaHajriNo", type: "number", visible: false },
                        { name: "Id", type: "text", width: 60, visible: false }
                    ]
                });
            }

            $("#detailsDialog").dialog({
                autoOpen: false,
                width: 400,
                close: function () {
                    $("#detailsForm").validate().resetForm();
                    $("#detailsForm").find(".error").removeClass("error");
                }
            });

            $("#detailsForm").validate({
                rules: {
                    name: "required",
                    reciptno: "required",
                    mobilenumber: "required"
                },
                submitHandler: function () {
                    formSubmitHandler();
                }
            });

            var formSubmitHandler = $.noop;

            var showDetailsDialog = function (dialogType, client) {
                $("#id").val(client.Id);
                $("#chk2018").prop("checked", client.EntryIn2018);
                $("#reciptno").val(client.ReciptNo);
                $("#name").val(client.Name);
                $("#mobilenumber").val(client.MobileNumber);
                $("#whatsappnumber").val(client.WhatsAppNumber);
                $("#gam").val(client.Gam);
                $("#taluka").val(client.Taluka);
                $("#jillo").val(client.Jillo);
                $("#age").val(client.Age);
                $("#address").val(client.Address);
                $("#email").val(client.Email);
                $("#availableatkalakunjsabha").val(client.AvailableAtKalakunjSabha);
                $("#sabhahajrino").val(client.SabhaHajriNo);
                $("#staydaysinshibir").val(client.StayDaysInShibir);
                var dfrom;
                if (client.StayFromDate == undefined || client.StayFromDate == 'undefined') {
                    dfrom = new Date();
                } else {
                    dfrom = new Date(client.StayFromDate);
                }

                $("#stayfromdate").val(dfrom.getFullYear() + "-" + ("0" + (dfrom.getMonth() + 1)).slice(-2) + "-" + ("0" + dfrom.getDate()).slice(-2));

                var dto;
                if (client.StayToDate == undefined || client.StayToDate == 'undefined') {
                    dto = new Date();
                } else {
                    dto = new Date(client.StayToDate);
                }
                $("#staytodate").val(dto.getFullYear() + "-" + ("0" + (dto.getMonth() + 1)).slice(-2) + "-" + ("0" + dto.getDate()).slice(-2));

                $("#howmanytimesinshibir").val(client.HowmanyTimesInShibir);


                formSubmitHandler = function () {
                    saveClient(client, dialogType === "Add");
                };

                $("#detailsDialog").dialog("option", "title", dialogType + " Person");
                $("#detailsDialog").dialog("option", "width", 800)
                    .dialog("open");
            };

            var saveClient = function (client, isNew) {
                client = {
                    Id: $("#id").val(),
                    EntryIn2018: $("#chk2018").prop("checked"),
                    ReciptNo: $("#reciptno").val(),
                    Name: $("#name").val(),
                    MobileNumber: $("#mobilenumber").val(),
                    WhatsAppNumber: $("#whatsappnumber").val(),
                    Gam: $("#gam").val(),
                    Taluka: $("#taluka").val(),
                    Jillo: $("#jillo").val(),
                    Age: $("#age").val(),
                    Address: $("#address").val(),
                    Email: $("#email").val(),
                    AvailableAtKalakunjSabha: $("#availableatkalakunjsabha").val(),
                    SabhaHajriNo: $("#sabhahajrino").val(),
                    StayDaysInShibir: $("#staydaysinshibir").val(),
                    StayFromDate: new Date($("#stayfromdate").val()),
                    StayToDate: new Date($("#staytodate").val()),
                    HowmanyTimesInShibir: $("#howmanytimesinshibir").val()
                };

                $("#jqGrid").jsGrid(isNew ? "insertItem" : "updateItem", client);
                ;
                $("#detailsDialog").dialog("close");
            };
        });

        function formatDate(date) {

            var monthNames = [
                "January", "February", "March",
                "April", "May", "June", "July",
                "August", "September", "October",
                "November", "December"
            ];

            var day = date.getDate();
            var monthIndex = date.getMonth();
            var year = date.getFullYear();

            return day + ' ' + monthNames[monthIndex] + ' ' + year;
        }
    </script>
</asp:Content>

