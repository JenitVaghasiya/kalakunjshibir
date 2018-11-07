using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class shibirlist : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [System.Web.Services.WebMethod]
    public static string GetAllPerson()
    {
        return JsonConvert.SerializeObject(PersonDetailRepository.GetAllPerson());
    }

    [System.Web.Services.WebMethod]
    public static bool InsertData(PersonDetail data)
    {
        return PersonDetailRepository.InsertData(data);
    }

    [System.Web.Services.WebMethod]
    public static bool UpdateData(PersonDetail data)
    {
        return PersonDetailRepository.UpdateData(data);
    }

    [System.Web.Services.WebMethod]
    public static bool DeleteData(PersonDetail data)
    {
        return PersonDetailRepository.DeleteData(data);
    }
}