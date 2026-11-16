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
												name = {
													value = "isOfflineFrequents",
													kind = "Name"
												},
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
																value = "username",
																kind = "Name"
															},
															kind = "Field",
															directives = {}
														},
														{
															arguments = {},
															name = {
																value = "displayName",
																kind = "Name"
															},
															kind = "Field",
															directives = {}
														}
													}
												},
												arguments = {},
												name = { value = "mutualFriends", kind = "Name" },
												kind = "Field",
												directives = {}
											}
										}
									},
									arguments = {},
									name = { value = "profileInsights", kind = "Name" },
									kind = "Field",
									directives = {}
								}
							}
						},
						arguments = {
							{
								value = {
									kind = "Variable",
									name = { value = "userIds", kind = "Name" }
								},
								kind = "Argument",
								name = { value = "userIds", kind = "Name" }
							},
							{
								value = {
									kind = "Variable",
									name = { value = "count", kind = "Name" }
								},
								kind = "Argument",
								name = { value = "count", kind = "Name" }
							},
							{
								value = {
									kind = "Variable",
									name = { value = "pageId", kind = "Name" }
								},
								kind = "Argument",
								name = { value = "pageId", kind = "Name" }
							},
							{
								value = {
									kind = "Variable",
									name = { value = "rankingStrategy", kind = "Name" }
								},
								kind = "Argument",
								name = { value = "rankingStrategy", kind = "Name" }
							}
						},
						name = { value = "profilesInsights", kind = "Name" },
						kind = "Field",
						directives = {}
					}
				}
			},
			directives = {},
			name = { value = "ProfilesInsights", kind = "Name" },
			operation = "query",
			kind = "OperationDefinition",
			variableDefinitions = {
				{
					type = {
						kind = "NonNullType",
						type = {
							kind = "ListType",
							type = {
								kind = "NamedType",
								name = { value = "String", kind = "Name" }
							}
						}
					},
					directives = {},
					kind = "VariableDefinition",
					variable = {
						kind = "Variable",
						name = { value = "userIds", kind = "Name" }
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
						name = { value = "count", kind = "Name" }
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
						name = { value = "pageId", kind = "Name" }
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
						name = { value = "rankingStrategy", kind = "Name" }
					}
				}
			}
		}
	},
	kind = "Document"
}
