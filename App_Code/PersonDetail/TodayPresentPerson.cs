using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for TodayPresentPerson
/// </summary>

[Table("TodayPresentPerson", Schema = "dbo")]
public class TodayPresentPerson
{
    [Key]
    public int? Id { get; set; }

    public string PersonId { get; set; }

    public DateTime PresentDate { get; set; }

    public TodayPresentPerson()
    {
        //
        // TODO: Add constructor logic here
        //
    }
}