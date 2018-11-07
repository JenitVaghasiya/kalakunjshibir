using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(kalakunjshibir2017.Startup))]
namespace kalakunjshibir2017
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
