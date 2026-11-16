return {
	definitions = {
		{
			selectionSet = {
				kind = "SelectionSet",
				selections = {
					{
						selectionSet = {
							kind = "SelectionSet",
							selections = {
								{
									arguments = {},
									name = { value = "id", kind = "Name" },
									kind = "Field",
									directives = {}
								},
								{
									arguments = {},
									name = { value = "targetUserId", kind = "Name" },
									kind = "Field",
									directives = {}
								},
								{
									selectionSet = {
										kind = "SelectionSet",
										selections = {
											{
												arguments = {},
												name = { value = "id", kind = "Name" },
												kind = "Field",
												directives = {}
											},
											{
												arguments = {},
												name = {
													value = "userPresenceType",
													kind = "Name"
												},
												kind = "Field",
												directives = {}
											},
											{
												arguments = {},
												name = {
													value = "lastLocation",
													kind = "Name"
												},
												kind = "Field",
												directives = {}
											},
											{
												arguments = {},
												name = {
													value = "lastOnline",
													kind = "Name"
												},
												kind = "Field",
												directives = {}
											},
											{
												arguments = {},
												name = {
													value = "placeId",
													kind = "Name"
												},
												kind = "Field",
												directives = {}
											},
											{
												arguments = {},
												name = {
													value = "rootPlaceId",
													kind = "Name"
												},
												kind = "Field",
												directives = {}
											},
											{
												arguments = {},
												name = {
													value = "gameId",
													kind = "Name"
												},
												kind = "Field",
												directives = {}
											},
											{
												arguments = {},
												name = {
													value = "universeId",
													kind = "Name"
												},
												kind = "Field",
												directives = {}
											}
										}
									},
									arguments = {},
									name = { value = "presence", kind = "Name" },
									kind = "Field",
									directives = {}
								},
								{
									arguments = {},
									name = { value = "sortScore", kind = "Name" },
									kind = "Field",
									directives = {}
								}
							}
						},
						arguments = {
							{
								value = {
									kind = "Variable",
									name = { value = "userId", kind = "Name" }
								},
								kind = "Argument",
								name = { value = "userId", kind = "Name" }
							},
							{
								value = {
									kind = "Variable",
									name = { value = "sort", kind = "Name" }
								},
								kind = "Argument",
								name = { value = "sort", kind = "Name" }
							}
						},
						name = { value = "onlineFriendsByUserId", kind = "Name" },
						kind = "Field",
						directives = {}
					}
				}
			},
			directives = {},
			name = { value = "OnlineFriendsByUserId", kind = "Name" },
			operation = "query",
			kind = "OperationDefinition",
			variableDefinitions = {
				{
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ID", kind = "Name" }
						}
					},
					directives = {},
					kind = "VariableDefinition",
					variable = {
						kind = "Variable",
						name = { value = "userId", kind = "Name" }
					}
				},
				{
					type = {
						kind = "NamedType",
						name = { value = "Int", kind = "Name" }
					},
					directives = {},
					kind = "VariableDefinition",
					variable = {
						kind = "Variable",
						name = { value = "sort", kind = "Name" }
					}
				}
			}
		}
	},
	kind = "Document"
}
