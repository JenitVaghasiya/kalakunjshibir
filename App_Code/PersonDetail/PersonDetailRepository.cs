using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Dapper;
using DapperExtensions;
using System.Data;
/// <summary>
/// Summary description for PersonDetailRepository
/// </summary>
public class PersonDetailRepository
{
    public static IEnumerable<PersonDetail> GetAllPerson()
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            dbConnection.Open();
            return dbConnection.Query<PersonDetail>("SELECT pd.*,tpp.PresentDate FROM PersonDetail pd Left join TodayPresentPerson tpp on tpp.PersonId = pd.Id and tpp.PresentDate = convert(date, getdate())");
        }
    }

    public static bool InsertData(PersonDetail data)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            dbConnection.Open();
            using (var tran = dbConnection.BeginTransaction())
            {
                try
                {
                    if (data.StayFromDate.HasValue)
                    {
                        data.StayFromDate = data.StayFromDate.Value.ToUniversalTime();
                    }

                    if (data.StayToDate.HasValue)
                    {
                        data.StayToDate = data.StayToDate.Value.ToUniversalTime();
                    }
                    DapperExtensions.DapperExtensions.SetMappingAssemblies(new[] { typeof(PersonDetail).Assembly });
                    dbConnection.Insert(data, tran);
                    tran.Commit();
                    return true;
                }
                catch (Exception ex)
                {
                    tran.Rollback();
                    return false;
                }
            }

        }
    }


    public static bool UpdateData(PersonDetail data)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            dbConnection.Open();
            using (var tran = dbConnection.BeginTransaction())
            {
                try
                {
                    if (data.StayFromDate.HasValue)
                    {
                        data.StayFromDate = data.StayFromDate.Value.ToUniversalTime();
                    }

                    if (data.StayToDate.HasValue)
                    {
                        data.StayToDate = data.StayToDate.Value.ToUniversalTime();
                    }

                    DapperExtensions.DapperExtensions.SetMappingAssemblies(new[] { typeof(PersonDetail).Assembly });
                    dbConnection.Update(data, tran);
                    tran.Commit();
                    return true;
                }
                catch (Exception ex)
                {
                    tran.Rollback();
                    return false;
                }
            }

        }
    }

    public static bool DeleteData(PersonDetail data)
    {
        using (IDbConnection dbConnection = DBConnection.Connection)
        {
            dbConnection.Open();
            using (var tran = dbConnection.BeginTransaction())
            {
                try
                {
                    DapperExtensions.DapperExtensions.SetMappingAssemblies(new[] { typeof(PersonDetail).Assembly });
                    dbConnection.Delete(data, tran);
                    tran.Commit();
                    return true;
                }
                catch (Exception ex)
                {
                    tran.Rollback();
                    return false;
                }
            }

        }
    }

    public PersonDetailRepository()
    {
        //
        // TODO: Add constructor logic here
        //
    }
}