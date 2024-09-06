import Fluent

struct AddColumnToUserMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("users")
            .field("new_column", .string)
            .update()
    }

    func revert(on database: Database) async throws {
        try await database.schema("users")
            .deleteField("new_column")
            .update()
    }
}