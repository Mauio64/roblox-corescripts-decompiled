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
									name = { value = "targetUserId", kind = "Name" },
									kind = "Field",
									directives = {}
								},
								{
									arguments = {},
									name = { value = "prevCursor", kind = "Name" },
									kind = "Field",
									directives = {}
								},
								{
									arguments = {},
									name = { value = "nextCursor", kind = "Name" },
									kind = "Field",
									directives = {}
								},
								{
									arguments = {},
									name = { value = "curCursor", kind = "Name" },
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
												name = { value = "targetUserId", kind = "Name" },
												kind = "Field",
												directives = {}
											},
											{
												arguments = {},
												name = { value = "hasVerifiedBadge", kind = "Name" },
												kind = "Field",
												directives = {}
											}
										}
									},
									arguments = {},
									name = { value = "friends", kind = "Name" },
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
							},
							{
								value = {
									kind = "Variable",
									name = { value = "pageLimit", kind = "Name" }
								},
								kind = "Argument",
								name = { value = "pageLimit", kind = "Name" }
							},
							{
								value = {
									kind = "Variable",
									name = { value = "pageCursor", kind = "Name" }
								},
								kind = "Argument",
								name = { value = "pageCursor", kind = "Name" }
							}
						},
						name = { value = "allFriendsByUserId", kind = "Name" },
						kind = "Field",
						directives = {}
					}
				}
			},
			directives = {},
			name = { value = "AllFriendsByUserId", kind = "Name" },
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
						name = { value = "pageLimit", kind = "Name" }
					}
				},
				{
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					directives = {},
					kind = "VariableDefinition",
					variable = {
						kind = "Variable",
						name = { value = "pageCursor", kind = "Name" }
					}
				}
			}
		}
	},
	kind = "Document"
}
