import Fluent

   struct NewTestMigration: AsyncMigration {
       func prepare(on database: Database) async throws {
           try await database.schema("test_table")
               .id()
               .field("name", .string)
               .create()
       }

       func revert(on database: Database) async throws {
           try await database.schema("test_table").delete()
       }
   }