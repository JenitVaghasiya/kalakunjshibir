using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

/// <summary>
/// Summary description for PersonDetail
/// </summary>
[Table("PersonDetail", Schema = "dbo")]
public class PersonDetail
{
    [Key]
    public int? Id { get; set; }

    public string ReciptNo { get; set; }

    public string Name { get; set; }

    public string MobileNumber { get; set; }

    public string Gam { get; set; }

    public string Taluka { get; set; }

    public string Jillo { get; set; }

    public int? Age { get; set; }

    public string Address { get; set; }

    public string WhatsAppNumber { get; set; }

    public string Email { get; set; }

    public string AvailableAtKalakunjSabha { get; set; }

    public string SabhaHajriNo { get; set; }

    public int? StayDaysInShibir { get; set; }

    public DateTime? StayFromDate { get; set; }

    public DateTime? StayToDate { get; set; }

    public int? HowmanyTimesInShibir { get; set; }

    //public DateTime? PresentDate { get; set; }

    //public bool IsPresentToday
    //{
        //get
        //{
            //return PresentDate.HasValue && PresentDate.Value.Date > new DateTime(0001, 01, 01);
        //}
    // }

    public bool EntryIn2018 { get; set; }

    public PersonDetail()
    {
    }
}