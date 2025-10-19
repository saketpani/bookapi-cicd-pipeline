using Microsoft.AspNetCore.Mvc;

namespace BookApi.Controllers;

[ApiController]
[Route("api/books")]
public class BookController : ControllerBase
{
    private static readonly Book[] Books = new[]
    {
        new Book(1, "The Great Gatsby", "F. Scott Fitzgerald", 1925, "Classic American Literature"),
        new Book(2, "Lord of the Rings", "Tolkien", 1954, "A fantasy novel"),
        new Book(3, "1984", "George Orwell", 1949, "Dystopian Science Fiction"),
        new Book(4, "Pride and Prejudice", "Jane Austen", 1813, "Romantic Fiction")
    };

    [HttpGet]
    public IEnumerable<Book> Get()
    {
        return Books;
    }

    [HttpGet("{id}")]
    public IActionResult GetById(int id)
    {
        var book = Books.FirstOrDefault(b => b.Id == id);
        return book != null ? Ok(book) : NotFound();
    }

    [HttpGet("health")]
    public IActionResult Health()
    {
        return Ok(new { Status = "Healthy", Timestamp = DateTime.UtcNow, Version = "1.0.0", TotalBooks = Books.Length });
    }
}

public record Book(int Id, string Title, string Author, int Year, string Genre);