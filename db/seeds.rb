# frozen_string_literal: true
# BookShelf demo data seed — idempotent, re-runnable
puts "Seeding database..."

# ── Users ──────────────────────────────────────────────────────────
users_data = [
  { email: "cenius@cenius.ai",     name: "Cenius",           role: :admin,  password: "cenius" },
  { email: "amelia.clarke@demo.ai", name: "Amelia Clarke",    role: :member, password: "password123" },
  { email: "marcus.chen@demo.ai",   name: "Marcus Chen",      role: :member, password: "password123" },
  { email: "zara.owusu@demo.ai",    name: "Zara Owusu",       role: :member, password: "password123" },
  { email: "leo.kovac@demo.ai",     name: "Leo Kovac",        role: :member, password: "password123" },
  { email: "priya.sharma@demo.ai",  name: "Priya Sharma",     role: :member, password: "password123" },
]

users = users_data.map do |attrs|
  User.find_or_create_by!(email: attrs[:email]) do |u|
    u.name = attrs[:name]
    u.role = attrs[:role]
    u.password = attrs[:password]
  end
end

puts "  Users: #{User.count}"

# ── Books ──────────────────────────────────────────────────────────
books_data = [
  { title: "The Shape of Data",                  author: "Elena Voss",         isbn: "978-0-316-42987-2", description: "A journey through the geometries that underlie modern machine learning, from hyperplanes to manifold learning." },
  { title: "Concrete Horizons",                  author: "James Okonkwo",      isbn: "978-1-5247-3789-5", description: "A sweeping architectural history of post-war urban renewal and its unintended consequences on community life." },
  { title: "Silicon Garden",                     author: "Mei Lin",            isbn: "978-0-7352-1891-2", description: "A near-future speculative novel exploring bio-digital interfaces and what it means to grow consciousness in code." },
  { title: "The Quiet Compiler",                 author: "Raj Patel",          isbn: "978-0-141-98372-0", description: "Essays on the craftsmanship of systems programming, compiler design, and the beauty of deterministic computation." },
  { title: "Tides of Salt and Steel",            author: "Sofia Reyes",        isbn: "978-1-9821-4567-3", description: "Historical fiction set in a 19th-century shipbuilding town, weaving family saga with industrial revolution." },
  { title: "Nonlinear",                          author: "David Abramov",      isbn: "978-0-06-293820-6", description: "A concise introduction to nonlinear dynamics, chaos theory, and emergent behavior in complex systems." },
  { title: "The Borrowed Garden",                author: "Hana Yoshida",       isbn: "978-0-440-24567-8", description: "A meditation on urban nature, community gardens, and the small acts of care that sustain public spaces." },
  { title: "Proof by Candlelight",               author: "Thabo Mbeki Jr.",    isbn: "978-0-571-34521-8", description: "Mathematical puzzles and the stories of the mathematicians who solved them, from ancient Alexandria to modern Cambridge." },
  { title: "After the Monsoon",                  author: "Ananya Krishnan",    isbn: "978-0-553-41987-2", description: "A novel about three generations of women in Kerala navigating tradition, diaspora, and the changing climate." },
  { title: "The Systems Reader",                 author: "Ivan Petrov",        isbn: "978-0-262-52891-5", description: "A curated collection of foundational texts on systems thinking, cybernetics, and organizational design." },
  { title: "Glass Mountain",                     author: "Clara Fontaine",     isbn: "978-1-250-17890-4", description: "Literary fiction exploring ambition, sacrifice, and the alpine climbing community in the French Alps." },
  { title: "Bytes and Belief",                   author: "Omar Hassan",        isbn: "978-0-307-94567-9", description: "An investigation into how software architectures reflect and reinforce belief systems, from open source to surveillance capitalism." },
  { title: "The Last Cartographer",              author: "Nina Bergstrom",     isbn: "978-0-451-49876-5", description: "In a world where maps are alive and territory shifts daily, the last cartographer must navigate a city that doesn't want to be mapped." },
  { title: "Rhythm and Root",                    author: "Kwame Asante",       isbn: "978-0-399-58234-5", description: "A deep dive into West African drumming traditions and their mathematical underpinnings in polyrhythm and fractal patterns." },
  { title: "Empirical Methods for Curious Minds", author: "Dr. Sarah Klein",   isbn: "978-1-316-63450-2", description: "A practical handbook on experimental design, statistical reasoning, and the scientific method for citizen scientists." },
  { title: "The Ferryman's Log",                 author: "Lars Nilsson",       isbn: "978-0-8021-4678-9", description: "Short stories from the Stockholm archipelago, each centered on a ferry crossing and the passengers' intersecting lives." },
  { title: "Database Dreams",                    author: "Violet Chen",        isbn: "978-1-491-95678-2", description: "A practitioner's guide to database internals, query optimization, and the art of data modeling with real-world case studies." },
  { title: "Wild Type",                          author: "Dr. Marco Rivera",   isbn: "978-0-300-23456-1", description: "CRISPR, gene drives, and the ethical frontier of genetic engineering — a balanced account from a working biologist." },
  { title: "The Patina of Memory",               author: "Yuki Tanaka",        isbn: "978-0-374-71234-5", description: "A memoir of growing up between Tokyo and rural Hokkaido, examining how places shape identity across two cultures." },
  { title: "Finite Automata",                    author: "Alexei Morozov",     isbn: "978-0-12-345678-9", description: "A rigorous yet accessible textbook on automata theory, formal languages, and computational complexity for undergraduates." },
  { title: "Coral Radio",                        author: "Fatima Al-Rashid",   isbn: "978-0-670-89123-0", description: "Climate fiction set in a floating city above a dying reef, where a radio operator intercepts transmissions from the deep." },
  { title: "The Uncommon Reader",                author: "Penelope Bright",    isbn: "978-0-15-603345-9", description: "A librarian's memoir of the strangest patron requests she's ever received and what they reveal about human curiosity." },
  { title: "Playing with Fire: The Hot Sauce Economy", author: "Carlos Mendez", isbn: "978-1-59463-890-2", description: "From Scoville scales to global supply chains, a flavorful economic history of capsaicin and the people who chase it." },
]

books = books_data.map do |attrs|
  Book.find_or_create_by!(isbn: attrs[:isbn]) do |b|
    b.title = attrs[:title]
    b.author = attrs[:author]
    b.description = attrs[:description]
  end
end

puts "  Books: #{Book.count}"

# ── Loans ──────────────────────────────────────────────────────────
# Only create loans if none exist (idempotent)
if Loan.count.zero?
  today = Date.current

  # Active loans: borrow various books for different users
  Loan.create!(
    user: users[1], book: books[0],
    borrowed_at: today - 5.days
  )
  Loan.create!(
    user: users[2], book: books[2],
    borrowed_at: today - 12.days
  )
  Loan.create!(
    user: users[3], book: books[4],
    borrowed_at: today - 3.days
  )
  Loan.create!(
    user: users[4], book: books[6],
    borrowed_at: today - 18.days   # overdue (>14 days)
  )
  Loan.create!(
    user: users[1], book: books[8],
    borrowed_at: today - 1.day
  )
  Loan.create!(
    user: users[5], book: books[10],
    borrowed_at: today - 7.days
  )
  Loan.create!(
    user: users[2], book: books[12],
    borrowed_at: today - 2.days
  )
  Loan.create!(
    user: users[3], book: books[14],
    borrowed_at: today - 20.days   # overdue
  )

  # Returned loans (historical)
  returned_loan = Loan.create!(
    user: users[4], book: books[1],
    borrowed_at: today - 30.days
  )
  returned_loan.update!(returned_at: today - 16.days)

  returned_loan2 = Loan.create!(
    user: users[5], book: books[3],
    borrowed_at: today - 25.days
  )
  returned_loan2.update!(returned_at: today - 12.days)

  returned_loan3 = Loan.create!(
    user: users[1], book: books[5],
    borrowed_at: today - 10.days
  )
  returned_loan3.update!(returned_at: today - 3.days)

  puts "  Loans: #{Loan.count} (#{Loan.active.count} active, #{Loan.overdue.count} overdue)"
else
  puts "  Loans already seeded (#{Loan.count} total, #{Loan.active.count} active)"
end

puts "Seed complete!"
