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
									name = { value = "cursor", kind = "Name" },
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
												name = { value = "title", kind = "Name" },
												kind = "Field",
												directives = {}
											},
											{
												arguments = {},
												name = { value = "displayTitle", kind = "Name" },
												kind = "Field",
												directives = {}
											},
											{
												arguments = {},
												name = { value = "subtitle", kind = "Name" },
												kind = "Field",
												directives = {}
											},
											{
												arguments = {},
												name = { value = "displaySubtitle", kind = "Name" },
												kind = "Field",
												directives = {}
											},
											{
												arguments = {},
												name = { value = "universeId", kind = "Name" },
												kind = "Field",
												directives = {}
											},
											{
												arguments = {},
												name = { value = "placeId", kind = "Name" },
												kind = "Field",
												directives = {}
											},
											{
												arguments = {},
												name = { value = "description", kind = "Name" },
												kind = "Field",
												directives = {}
											},
											{
												arguments = {},
												name = {
													value = "displayDescription",
													kind = "Name"
												},
												kind = "Field",
												directives = {}
											},
											{
												arguments = {},
												name = { value = "eventStatus", kind = "Name" },
												kind = "Field",
												directives = {}
											},
											{
												selectionSet = {
													kind = "SelectionSet",
													selections = {
														{
															arguments = {},
															name = {
																value = "startUtc",
																kind = "Name"
															},
															kind = "Field",
															directives = {}
														},
														{
															arguments = {},
															name = {
																value = "endUtc",
																kind = "Name"
															},
															kind = "Field",
															directives = {}
														}
													}
												},
												arguments = {},
												name = { value = "eventTime", kind = "Name" },
												kind = "Field",
												directives = {}
											},
											{
												selectionSet = {
													kind = "SelectionSet",
													selections = {
														{
															arguments = {},
															name = {
																value = "category",
																kind = "Name"
															},
															kind = "Field",
															directives = {}
														},
														{
															arguments = {},
															name = { value = "rank", kind = "Name" },
															kind = "Field",
															directives = {}
														}
													}
												},
												arguments = {},
												name = { value = "eventCategories", kind = "Name" },
												kind = "Field",
												directives = {}
											},
											{
												arguments = {},
												name = { value = "userRsvpStatus", kind = "Name" },
												kind = "Field",
												directives = {}
											}
										}
									},
									arguments = {},
									name = { value = "virtualEvents", kind = "Name" },
									kind = "Field",
									directives = {}
								}
							}
						},
						arguments = {
							{
								value = {
									kind = "Variable",
									name = { value = "universeId", kind = "Name" }
								},
								kind = "Argument",
								name = { value = "universeId", kind = "Name" }
							},
							{
								value = {
									kind = "Variable",
									name = { value = "options", kind = "Name" }
								},
								kind = "Argument",
								name = { value = "options", kind = "Name" }
							}
						},
						name = { value = "virtualEventsByUniverseId", kind = "Name" },
						kind = "Field",
						directives = {}
					}
				}
			},
			directives = {},
			name = { value = "VirtualEventsForExperience", kind = "Name" },
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
						name = { value = "universeId", kind = "Name" }
					}
				},
				{
					type = {
						kind = "NamedType",
						name = { value = "VirtualEventsByUniverseIdOptions", kind = "Name" }
					},
					directives = {},
					kind = "VariableDefinition",
					variable = {
						kind = "Variable",
						name = { value = "options", kind = "Name" }
					}
				}
			}
		}
	},
	kind = "Document"
}
