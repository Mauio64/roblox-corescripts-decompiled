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
									selectionSet = {
										kind = "SelectionSet",
										selections = {
											{
												arguments = {},
												name = {
													value = "featureName",
													kind = "Name"
												},
												kind = "Field",
												directives = {}
											},
											{
												arguments = {},
												name = {
													value = "access",
													kind = "Name"
												},
												kind = "Field",
												directives = {}
											},
											{
												arguments = {},
												name = {
													value = "recourse",
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
															name = {
																value = "action",
																kind = "Name"
															},
															kind = "Field",
															directives = {}
														},
														{
															arguments = {},
															name = {
																value = "parentConsentTypes",
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
																		name = {
																			value = "settingName",
																			kind = "Name"
																		},
																		kind = "Field",
																		directives = {}
																	},
																	{
																		arguments = {},
																		name = {
																			value = "settingValue",
																			kind = "Name"
																		},
																		kind = "Field",
																		directives = {}
																	}
																}
															},
															arguments = {},
															name = {
																value = "userSettings",
																kind = "Name"
															},
															kind = "Field",
															directives = {}
														}
													}
												},
												arguments = {},
												name = {
													value = "recourses",
													kind = "Name"
												},
												kind = "Field",
												directives = {}
											}
										}
									},
									arguments = {},
									name = { value = "featureAccess", kind = "Name" },
									kind = "Field",
									directives = {}
								},
								{
									arguments = {},
									name = { value = "shouldPrompt", kind = "Name" },
									kind = "Field",
									directives = {}
								}
							}
						},
						arguments = {
							{
								value = {
									kind = "Variable",
									name = { value = "featureName", kind = "Name" }
								},
								kind = "Argument",
								name = { value = "featureName", kind = "Name" }
							},
							{
								value = {
									kind = "Variable",
									name = {
										value = "successfulActions",
										kind = "Name"
									}
								},
								kind = "Argument",
								name = { value = "successfulActions", kind = "Name" }
							},
							{
								value = {
									kind = "Variable",
									name = { value = "nameSpace", kind = "Name" }
								},
								kind = "Argument",
								name = { value = "nameSpace", kind = "Name" }
							},
							{
								value = {
									kind = "Variable",
									name = { value = "extraParameters", kind = "Name" }
								},
								kind = "Argument",
								name = { value = "extraParameters", kind = "Name" }
							}
						},
						name = { value = "getUpsellFeatureAccess", kind = "Name" },
						kind = "Field",
						directives = {}
					}
				}
			},
			directives = {},
			name = { value = "GetUpsellFeatureAccess", kind = "Name" },
			operation = "query",
			kind = "OperationDefinition",
			variableDefinitions = {
				{
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "String", kind = "Name" }
						}
					},
					directives = {},
					kind = "VariableDefinition",
					variable = {
						kind = "Variable",
						name = { value = "featureName", kind = "Name" }
					}
				},
				{
					type = {
						kind = "ListType",
						type = {
							kind = "NamedType",
							name = { value = "RecourseActions", kind = "Name" }
						}
					},
					directives = {},
					kind = "VariableDefinition",
					variable = {
						kind = "Variable",
						name = { value = "successfulActions", kind = "Name" }
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
						name = { value = "nameSpace", kind = "Name" }
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
						name = { value = "extraParameters", kind = "Name" }
					}
				}
			}
		}
	},
	kind = "Document"
}
