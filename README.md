** for English speakers: you will find the translated version of this same read.me right after the Spanish one

# Proyecto de Consultas para Base de Datos de Alquiler de Películas

## Descripción General
Este proyecto tiene como objetivo optimizar la recolección de resultados concretos desde la base de datos de un negocio de alquiler de películas. A través de consultas SQL, permite obtener información valiosa tanto para la gestión del negocio como para mejorar la experiencia de los clientes, ahorrando tiempo en la búsqueda y ayudando a sacar conclusiones clave sobre la operación.

## Estado del Proyecto
Este proyecto está **finalizado**. En el futuro, se planea mejorar el código y ampliar el repertorio de consultas para obtener resultados aún más específicos y personalizados.

## Tecnologías Utilizadas
- **Base de datos**: Biblioteca "sakila" versión 2024.
- **Entorno de desarrollo**: MySQLWorkbench 8.0.

## Bugs Conocidos
- **Consulta de actores en la misma película**: La consulta que devuelve los actores que han actuado juntos en la misma película cumple con el objetivo esperado, pero el software podría entrar en un bucle y fallar en su ejecución bajo ciertas circunstancias.

## Preguntas Frecuentes

1. **¿Cuál es el propósito principal del proyecto?**
   - El propósito es ofrecer consultas eficientes para un negocio de alquiler de películas, obteniendo resultados concretos y valiosos para el negocio y sus clientes.

2. **¿Por qué puede entrar en bucle la consulta de actores?**
   - Esto puede ocurrir debido a problemas de optimización en la consulta; se recomienda revisar los índices en la base de datos y limitar el tamaño de los resultados para evitar este problema.




** ENGLISH VERSION:

# Movie Rental Database Query Project

## General Description
This project aims to optimize the retrieval of specific results from a movie rental business database. By using SQL queries, it provides valuable insights for both business management and customer experience, saving time on searches and helping to draw key conclusions about operations.

## Project Status
This project is **completed**. In the future, there are plans to improve the code and expand the range of queries to obtain even more specific and customized results.

## Technologies Used
- **Database**: "sakila" library version 2024.
- **Development environment**: MySQLWorkbench 8.0.

## Known Bugs
- **Actors in the Same Movie Query**: The query that returns actors who have acted together in the same movie meets the intended goal, but the software might enter an infinite loop and fail to execute under certain circumstances.

## Frequently Asked Questions

1. **What is the main purpose of the project?**
   - The main purpose is to provide efficient queries for a movie rental business, retrieving specific and valuable results for both the business and its customers.

2. **Why might the actors' query enter an infinite loop?**
   - This can happen due to optimization issues with the query; it's recommended to review database indexes and limit the size of results to avoid this problem.
