## Using BookShelf Manager

After starting the server (`bin/rails server`), open a browser and navigate to `http://localhost:3000`.

### Registration & Login

- **Sign up** at `/users/sign_up`
- **Log in** at `/users/sign_in`

Authentication is powered by [Devise](https://github.com/heartcombo/devise). Users are automatically created as regular members. Admin users must be set manually (e.g., via the Rails console).

### Member Features

- **Browse catalog**: The root page (`/`) lists all books. Click any book to view its details.
- **Borrow a book**: On a book’s detail page (`/books/:id`), if the book is available, a “Borrow” button appears. Click it to check out the book. The UI updates instantly via Turbo Stream.
- **Return a book**: If you currently have the book borrowed, a “Return” button replaces the borrow action. Click it to check in the book.

### Admin Features

Admins access management interfaces under `/admin`.

- **Add a new book**: Visit `/admin/books/new`, fill in the title, author, and other details, then submit. After creation, the book appears in the catalog.
- **View all loans**: The page `/admin/loans` lists every active loan, showing who has which book and when it was borrowed.

### Example cURL Interactions

*These examples assume a running local server and a valid session cookie. Obtain the CSRF token from the page’s `<meta>` tag or cookie.*

**Borrow a book** (POST request):

```bash
curl -X POST http://localhost:3000/books/1/loans \
  -H "Content-Type: application/json" \
  -H "X-CSRF-Token: your_token" \
  -b "_bookshelf_manager_session=your_session_cookie"
```

**Return a loan** (PATCH request):

```bash
curl -X PATCH http://localhost:3000/loans/1 \
  -H "Content-Type: application/json" \
  -H "X-CSRF-Token: your_token" \
  -b "_bookshelf_manager_session=your_session_cookie" \
  -d '{"loan":{"returned":true}}'
```

**Admin add book** (POST request):

```bash
curl -X POST http://localhost:3000/admin/books \
  -H "Content-Type: application/json" \
  -H "X-CSRF-Token: your_token" \
  -b "_bookshelf_manager_session=your_session_cookie" \
  -d '{"book":{"title":"New Title","author":"New Author"}}'
```

All responses may be Turbo Stream updates; the UI will change without a full page reload. For API-only usage, you may need to adapt the client to handle `text/vnd.turbo-stream.html` content type.

### Demo Credentials

After running `db:seed`, there are pre‑created members and an admin account. The seed data (`db/seeds.rb`) likely sets a known admin email/password (check the seed file for details).