using DoctorSkin.Repositories;
using Microsoft.Extensions.DependencyInjection;

namespace DoctorSkin.Extension
{
    public static class RepositoriesCollection
    {
        public static void AddRepositories(this IServiceCollection serviceCollection)
        {
            serviceCollection.AddTransient<ProductRepository, ProductRepository>();
        }
    }
}