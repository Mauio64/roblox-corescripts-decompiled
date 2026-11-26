local frozen = table.freeze({ Incoming = "Incoming", Outgoing = "Outgoing" })

local frozen2 = table.freeze({
	Only = "Only",
	First = "First",
	Middle = "Middle",
	Last = "Last"
})

return table.freeze({ Direction = frozen, Position = frozen2 })
