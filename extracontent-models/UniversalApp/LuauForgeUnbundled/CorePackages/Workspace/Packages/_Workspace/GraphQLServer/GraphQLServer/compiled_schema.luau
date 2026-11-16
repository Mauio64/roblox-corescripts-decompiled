return {
	definitions = {
		{
			directives = {},
			interfaces = {},
			kind = "InterfaceTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ID", kind = "Name" }
						}
					},
					name = { value = "id", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "String", kind = "Name" }
						}
					},
					name = { value = "displayName", kind = "Name" }
				}
			},
			name = { value = "User", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {
				{
					kind = "NamedType",
					name = { value = "User", kind = "Name" }
				}
			},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ID", kind = "Name" }
						}
					},
					name = { value = "id", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "String", kind = "Name" }
						}
					},
					name = { value = "displayName", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "String", kind = "Name" }
						}
					},
					name = { value = "avatarHeadshot", kind = "Name" }
				}
			},
			name = { value = "Player", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "User", kind = "Name" }
						}
					},
					name = { value = "me", kind = "Name" }
				},
				{
					arguments = {
						{
							type = {
								kind = "NonNullType",
								type = {
									kind = "NamedType",
									name = { value = "ID", kind = "Name" }
								}
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "id", kind = "Name" }
						}
					},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "User", kind = "Name" }
						}
					},
					name = { value = "user", kind = "Name" }
				},
				{
					arguments = {
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
							kind = "InputValueDefinition",
							name = { value = "userIds", kind = "Name" }
						},
						{
							type = {
								kind = "NamedType",
								name = { value = "Int", kind = "Name" }
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "count", kind = "Name" }
						},
						{
							type = {
								kind = "NamedType",
								name = { value = "String", kind = "Name" }
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "pageId", kind = "Name" }
						},
						{
							type = {
								kind = "NamedType",
								name = { value = "String", kind = "Name" }
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "rankingStrategy", kind = "Name" }
						}
					},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "ProfileInsightsPages", kind = "Name" }
					},
					name = { value = "profilesInsights", kind = "Name" }
				},
				{
					arguments = {
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
							kind = "InputValueDefinition",
							name = { value = "userIds", kind = "Name" }
						},
						{
							type = {
								kind = "NamedType",
								name = { value = "Int", kind = "Name" }
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "count", kind = "Name" }
						},
						{
							type = {
								kind = "NamedType",
								name = { value = "String", kind = "Name" }
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "rankingStrategy", kind = "Name" }
						}
					},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NamedType",
							name = { value = "ProfileInsights", kind = "Name" }
						}
					},
					name = { value = "profilesInsightsByUserIds", kind = "Name" }
				},
				{
					arguments = {
						{
							type = {
								kind = "NonNullType",
								type = {
									kind = "ListType",
									type = {
										kind = "NonNullType",
										type = {
											kind = "NamedType",
											name = { value = "String", kind = "Name" }
										}
									}
								}
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "universeIds", kind = "Name" }
						}
					},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NonNullType",
							type = {
								kind = "NamedType",
								name = { value = "Experience", kind = "Name" }
							}
						}
					},
					name = { value = "experienceThumbnails", kind = "Name" }
				},
				{
					arguments = {
						{
							type = {
								kind = "NamedType",
								name = { value = "String", kind = "Name" }
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "sessionId", kind = "Name" }
						},
						{
							type = {
								kind = "NamedType",
								name = { value = "String", kind = "Name" }
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "pageType", kind = "Name" }
						},
						{
							type = {
								kind = "NamedType",
								name = { value = "String", kind = "Name" }
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "nextPageToken", kind = "Name" }
						},
						{
							type = {
								kind = "ListType",
								type = {
									kind = "NamedType",
									name = { value = "String", kind = "Name" }
								}
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "supportedTreatmentTypes", kind = "Name" }
						}
					},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "OmniFeed", kind = "Name" }
					},
					name = { value = "omniFeed", kind = "Name" }
				},
				{
					arguments = {
						{
							type = {
								kind = "NonNullType",
								type = {
									kind = "NamedType",
									name = { value = "String", kind = "Name" }
								}
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "sortId", kind = "Name" }
						}
					},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "OmniFeedItem", kind = "Name" }
					},
					name = { value = "omniFeedItem", kind = "Name" }
				},
				{
					arguments = {
						{
							type = {
								kind = "NonNullType",
								type = {
									kind = "NamedType",
									name = { value = "String", kind = "Name" }
								}
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "sessionId", kind = "Name" }
						},
						{
							type = {
								kind = "NonNullType",
								type = {
									kind = "NamedType",
									name = { value = "String", kind = "Name" }
								}
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "topicId", kind = "Name" }
						},
						{
							type = {
								kind = "ListType",
								type = {
									kind = "NamedType",
									name = {
										value = "OmniFeedRecommendationDescriptor",
										kind = "Name"
									}
								}
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "recommendations", kind = "Name" }
						}
					},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "OmniFeedItemWithMetadata", kind = "Name" }
					},
					name = { value = "refreshOmniFeedItem", kind = "Name" }
				},
				{
					arguments = {
						{
							type = {
								kind = "NonNullType",
								type = {
									kind = "NamedType",
									name = { value = "ID", kind = "Name" }
								}
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "id", kind = "Name" }
						}
					},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "VirtualEvent", kind = "Name" }
					},
					name = { value = "virtualEvent", kind = "Name" }
				},
				{
					arguments = {
						{
							type = {
								kind = "NonNullType",
								type = {
									kind = "NamedType",
									name = { value = "ID", kind = "Name" }
								}
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "universeId", kind = "Name" }
						},
						{
							type = {
								kind = "NamedType",
								name = {
									value = "VirtualEventsByUniverseIdOptions",
									kind = "Name"
								}
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "options", kind = "Name" }
						}
					},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "VirtualEventsPage", kind = "Name" }
					},
					name = { value = "virtualEventsByUniverseId", kind = "Name" }
				},
				{
					arguments = {
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
							kind = "InputValueDefinition",
							name = { value = "userIds", kind = "Name" }
						}
					},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "ListType",
							type = {
								kind = "NamedType",
								name = { value = "UserProfile", kind = "Name" }
							}
						}
					},
					name = { value = "userProfiles", kind = "Name" }
				},
				{
					arguments = {
						{
							type = {
								kind = "ListType",
								type = {
									kind = "NamedType",
									name = { value = "String", kind = "Name" }
								}
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "featureNames", kind = "Name" }
						}
					},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "FeatureAccessResponse", kind = "Name" }
					},
					name = { value = "getFeatureAccess", kind = "Name" }
				},
				{
					arguments = {
						{
							type = {
								kind = "NamedType",
								name = { value = "String", kind = "Name" }
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "featureName", kind = "Name" }
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
							kind = "InputValueDefinition",
							name = { value = "successfulActions", kind = "Name" }
						},
						{
							type = {
								kind = "NamedType",
								name = { value = "String", kind = "Name" }
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "nameSpace", kind = "Name" }
						},
						{
							type = {
								kind = "NamedType",
								name = { value = "String", kind = "Name" }
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "extraParameters", kind = "Name" }
						}
					},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "UpsellFeatureAccessResponse", kind = "Name" }
					},
					name = { value = "getUpsellFeatureAccess", kind = "Name" }
				},
				{
					arguments = {
						{
							type = {
								kind = "NonNullType",
								type = {
									kind = "NamedType",
									name = { value = "ID", kind = "Name" }
								}
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "userId", kind = "Name" }
						},
						{
							type = {
								kind = "NamedType",
								name = { value = "Int", kind = "Name" }
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "sort", kind = "Name" }
						},
						{
							type = {
								kind = "NamedType",
								name = { value = "Int", kind = "Name" }
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "pageLimit", kind = "Name" }
						},
						{
							type = {
								kind = "NamedType",
								name = { value = "String", kind = "Name" }
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "pageCursor", kind = "Name" }
						}
					},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "AllFriendsPage", kind = "Name" }
					},
					name = { value = "allFriendsByUserId", kind = "Name" }
				},
				{
					arguments = {
						{
							type = {
								kind = "NonNullType",
								type = {
									kind = "NamedType",
									name = { value = "ID", kind = "Name" }
								}
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "userId", kind = "Name" }
						},
						{
							type = {
								kind = "NamedType",
								name = { value = "Int", kind = "Name" }
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "sort", kind = "Name" }
						}
					},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NamedType",
							name = { value = "Friend", kind = "Name" }
						}
					},
					name = { value = "onlineFriendsByUserId", kind = "Name" }
				},
				{
					arguments = {
						{
							type = {
								kind = "NonNullType",
								type = {
									kind = "NamedType",
									name = { value = "String", kind = "Name" }
								}
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "universeId", kind = "Name" }
						}
					},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ExperienceDetailsLink", kind = "Name" }
						}
					},
					name = {
						value = "experienceDetailsLinkByUniverseId",
						kind = "Name"
					}
				}
			},
			name = { value = "Query", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {
				{
					kind = "NamedType",
					name = { value = "User", kind = "Name" }
				}
			},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ID", kind = "Name" }
						}
					},
					name = { value = "id", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "String", kind = "Name" }
						}
					},
					name = { value = "username", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "String", kind = "Name" }
						}
					},
					name = { value = "displayName", kind = "Name" }
				}
			},
			name = { value = "MutualFriend", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ID", kind = "Name" }
						}
					},
					name = { value = "targetUserId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NonNullType",
							type = {
								kind = "NamedType",
								name = { value = "MutualFriend", kind = "Name" }
							}
						}
					},
					name = { value = "mutualFriends", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "Boolean", kind = "Name" }
						}
					},
					name = { value = "isOfflineFrequents", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Int", kind = "Name" }
					},
					name = { value = "friendshipAgeUnixSeconds", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Int", kind = "Name" }
					},
					name = { value = "friendRequestOriginSource", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Int", kind = "Name" }
					},
					name = { value = "accountCreationDateUnixSeconds", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "localizedCountryName", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "userAgeVerifiedBracket", kind = "Name" }
				}
			},
			name = { value = "ProfileInsights", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ID", kind = "Name" }
						}
					},
					name = { value = "id", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NonNullType",
							type = {
								kind = "NamedType",
								name = { value = "ProfileInsights", kind = "Name" }
							}
						}
					},
					name = { value = "profileInsights", kind = "Name" }
				}
			},
			name = { value = "ProfileInsightsPages", kind = "Name" }
		},
		{
			directives = {},
			kind = "EnumTypeDefinition",
			values = {
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "Image", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "YouTubeVideo", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "Video", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "GamePreviewVideo", kind = "Name" }
				}
			},
			name = { value = "MediaAssetType", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "ID", kind = "Name" }
					},
					name = { value = "assetTypeId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "MediaAssetType", kind = "Name" }
					},
					name = { value = "assetType", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "approved", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "ID", kind = "Name" }
					},
					name = { value = "imageId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "videoId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "videoHash", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "videoTitle", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "altText", kind = "Name" }
				}
			},
			name = { value = "ExperienceMedia", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ID", kind = "Name" }
						}
					},
					name = { value = "id", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "name", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "type", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "isRNVAccount", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "hasVerifiedBadge", kind = "Name" }
				}
			},
			name = { value = "ExperienceCreator", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ID", kind = "Name" }
						}
					},
					name = { value = "id", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "ID", kind = "Name" }
					},
					name = { value = "rootPlaceId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "name", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "description", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "sourceName", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "sourceDescription", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "ExperienceCreator", kind = "Name" }
					},
					name = { value = "creator", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Int", kind = "Name" }
					},
					name = { value = "price", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NamedType",
							name = { value = "String", kind = "Name" }
						}
					},
					name = { value = "allowedGearGenres", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NamedType",
							name = { value = "String", kind = "Name" }
						}
					},
					name = { value = "allowedGearCategories", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "isGenreEnforced", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "copyingAllowed", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Float", kind = "Name" }
					},
					name = { value = "playing", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Float", kind = "Name" }
					},
					name = { value = "visits", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Int", kind = "Name" }
					},
					name = { value = "maxPlayers", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "created", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "updated", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "studioAccessToApisAllowed", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "createVipServersAllowed", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Int", kind = "Name" }
					},
					name = { value = "universeAvatarType", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "genre", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "isAllGenre", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "isFavoritedByUser", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Float", kind = "Name" }
					},
					name = { value = "favoritedCount", kind = "Name" }
				}
			},
			name = { value = "ExperienceDetails", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ID", kind = "Name" }
						}
					},
					name = { value = "universeId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "placeId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "String", kind = "Name" }
						}
					},
					name = { value = "name", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Int", kind = "Name" }
					},
					name = { value = "totalUpVotes", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Int", kind = "Name" }
					},
					name = { value = "totalDownVotes", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Int", kind = "Name" }
					},
					name = { value = "playerCount", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "description", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "under9", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "under13", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "adId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "isSponsored", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NamedType",
							name = { value = "Media", kind = "Name" }
						}
					},
					name = { value = "thumbnails", kind = "Name" }
				}
			},
			name = { value = "Experience", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "url", kind = "Name" }
				}
			},
			name = { value = "Media", kind = "Name" }
		},
		{
			directives = {},
			kind = "ScalarTypeDefinition",
			name = { value = "JSONObject", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "OmniFeedMetadata", kind = "Name" }
					},
					name = { value = "metadata", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "pageType", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Int", kind = "Name" }
					},
					name = { value = "sortsExpirationTime", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "nextPageToken", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "isSessionExpired", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "recommendationsId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "JSONObject", kind = "Name" }
					},
					name = { value = "globalLayoutData", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "omniSessionId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NamedType",
							name = { value = "OmniFeedItem", kind = "Name" }
						}
					},
					name = { value = "sorts", kind = "Name" }
				}
			},
			name = { value = "OmniFeed", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {
						{
							kind = "Directive",
							name = { value = "deprecated", kind = "Name" },
							arguments = {
								{
									value = {
										value = "Fetch game metadata from OmniFeedItem instead. Scheduled for deprecation on 2023-01-30",
										kind = "StringValue",
										block = false
									},
									kind = "Argument",
									name = { value = "reason", kind = "Name" }
								}
							}
						}
					},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "JSONObject", kind = "Name" }
					},
					name = { value = "GameJSON", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "JSONObject", kind = "Name" }
					},
					name = { value = "CatalogAssetJSON", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "JSONObject", kind = "Name" }
					},
					name = { value = "CatalogBundleJSON", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "JSONObject", kind = "Name" }
					},
					name = { value = "RecommendedFriendJSON", kind = "Name" }
				}
			},
			name = { value = "OmniFeedMetadata", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "topicId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "topic", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "JSONObject", kind = "Name" }
					},
					name = { value = "topicLayoutData", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "treatmentType", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NamedType",
							name = { value = "OmniFeedRecommendation", kind = "Name" }
						}
					},
					name = { value = "recommendations", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NamedType",
							name = { value = "Experience", kind = "Name" }
						}
					},
					name = { value = "experiences", kind = "Name" }
				}
			},
			name = { value = "OmniFeedItem", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "contentType", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "contentId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "JSONObject", kind = "Name" }
					},
					name = { value = "contentMetadata", kind = "Name" }
				}
			},
			name = { value = "OmniFeedRecommendation", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "OmniFeedMetadata", kind = "Name" }
					},
					name = { value = "metadata", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "OmniFeedItem", kind = "Name" }
					},
					name = { value = "sort", kind = "Name" }
				}
			},
			name = { value = "OmniFeedItemWithMetadata", kind = "Name" }
		},
		{
			directives = {},
			kind = "InputObjectTypeDefinition",
			fields = {
				{
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					directives = {},
					kind = "InputValueDefinition",
					name = { value = "contentId", kind = "Name" }
				},
				{
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					directives = {},
					kind = "InputValueDefinition",
					name = { value = "contentType", kind = "Name" }
				}
			},
			name = { value = "OmniFeedRecommendationDescriptor", kind = "Name" }
		},
		{
			directives = {},
			kind = "EnumTypeDefinition",
			values = {
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "unpublished", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "active", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "cancelled", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "moderated", kind = "Name" }
				}
			},
			name = { value = "EventStatus", kind = "Name" }
		},
		{
			directives = {},
			kind = "EnumTypeDefinition",
			values = {
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "none", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "going", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "maybeGoing", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "notGoing", kind = "Name" }
				}
			},
			name = { value = "RsvpStatus", kind = "Name" }
		},
		{
			directives = {},
			kind = "EnumTypeDefinition",
			values = {
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "user", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "group", kind = "Name" }
				}
			},
			name = { value = "HostType", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "startUtc", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "endUtc", kind = "Name" }
				}
			},
			name = { value = "EventTime", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "ID", kind = "Name" }
					},
					name = { value = "hostId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "HostType", kind = "Name" }
					},
					name = { value = "hostType", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "hostName", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "hasVerifiedBadge", kind = "Name" }
				}
			},
			name = { value = "Host", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "ID", kind = "Name" }
					},
					name = { value = "userId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "RsvpStatus", kind = "Name" }
					},
					name = { value = "rsvpStatus", kind = "Name" }
				}
			},
			name = { value = "Rsvp", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Float", kind = "Name" }
					},
					name = { value = "none", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Float", kind = "Name" }
					},
					name = { value = "going", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Float", kind = "Name" }
					},
					name = { value = "maybeGoing", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Float", kind = "Name" }
					},
					name = { value = "notGoing", kind = "Name" }
				}
			},
			name = { value = "RsvpCounters", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "category", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Int", kind = "Name" }
					},
					name = { value = "rank", kind = "Name" }
				}
			},
			name = { value = "EventCategory", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ID", kind = "Name" }
						}
					},
					name = { value = "id", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "title", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "displayTitle", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "subtitle", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "displaySubtitle", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "description", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "displayDescription", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Host", kind = "Name" }
					},
					name = { value = "host", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "ID", kind = "Name" }
					},
					name = { value = "universeId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "placeId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "EventStatus", kind = "Name" }
					},
					name = { value = "eventStatus", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "EventTime", kind = "Name" }
					},
					name = { value = "eventTime", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "createdUtc", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "updatedUtc", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "RsvpStatus", kind = "Name" }
					},
					name = { value = "userRsvpStatus", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NamedType",
							name = { value = "EventCategory", kind = "Name" }
						}
					},
					name = { value = "eventCategories", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "ExperienceDetails", kind = "Name" }
					},
					name = { value = "experienceDetails", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NonNullType",
							type = {
								kind = "NamedType",
								name = { value = "ExperienceMedia", kind = "Name" }
							}
						}
					},
					name = { value = "media", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "RsvpCounters", kind = "Name" }
					},
					name = { value = "rsvpCounters", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NonNullType",
							type = {
								kind = "NamedType",
								name = { value = "Rsvp", kind = "Name" }
							}
						}
					},
					name = { value = "rsvps", kind = "Name" }
				}
			},
			name = { value = "VirtualEvent", kind = "Name" }
		},
		{
			directives = {},
			kind = "InputObjectTypeDefinition",
			fields = {
				{
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					directives = {},
					kind = "InputValueDefinition",
					name = { value = "cursor", kind = "Name" }
				},
				{
					type = {
						kind = "NamedType",
						name = { value = "Int", kind = "Name" }
					},
					directives = {},
					kind = "InputValueDefinition",
					name = { value = "limit", kind = "Name" }
				},
				{
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					directives = {},
					kind = "InputValueDefinition",
					name = { value = "fromUtc", kind = "Name" }
				}
			},
			name = { value = "VirtualEventsByUniverseIdOptions", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "cursor", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NonNullType",
							type = {
								kind = "NamedType",
								name = { value = "VirtualEvent", kind = "Name" }
							}
						}
					},
					name = { value = "virtualEvents", kind = "Name" }
				}
			},
			name = { value = "VirtualEventsPage", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = {
						value = "shouldSeeNotificationsUpsellModal",
						kind = "Name"
					}
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "VirtualEvent", kind = "Name" }
					},
					name = { value = "virtualEvent", kind = "Name" }
				}
			},
			name = { value = "RsvpResponse", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "neverShowNotificationModalAgain", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "enablePushNotifications", kind = "Name" }
				}
			},
			name = { value = "VirtualEventMutations", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "VirtualEventMutations", kind = "Name" }
						}
					},
					name = { value = "virtualEvents", kind = "Name" }
				},
				{
					arguments = {
						{
							type = {
								kind = "NonNullType",
								type = {
									kind = "NamedType",
									name = { value = "ID", kind = "Name" }
								}
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "id", kind = "Name" }
						},
						{
							type = {
								kind = "NonNullType",
								type = {
									kind = "NamedType",
									name = { value = "RsvpStatus", kind = "Name" }
								}
							},
							directives = {},
							kind = "InputValueDefinition",
							name = { value = "rsvpStatus", kind = "Name" }
						}
					},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "RsvpResponse", kind = "Name" }
					},
					name = { value = "virtualEventRsvp", kind = "Name" }
				}
			},
			name = { value = "Mutation", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "alias", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "combinedName", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "contactName", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "displayName", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "inExperienceCombinedName", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "username", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "platformName", kind = "Name" }
				}
			},
			name = { value = "Names", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {
				{
					kind = "NamedType",
					name = { value = "User", kind = "Name" }
				}
			},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ID", kind = "Name" }
						}
					},
					name = { value = "id", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "String", kind = "Name" }
						}
					},
					name = { value = "displayName", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Names", kind = "Name" }
					},
					name = { value = "names", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "platformProfileId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "isVerified", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "isDeleted", kind = "Name" }
				}
			},
			name = { value = "UserProfile", kind = "Name" }
		},
		{
			directives = {},
			kind = "EnumTypeDefinition",
			values = {
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "Granted", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "Denied", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "Actionable", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "Pending", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "Error", kind = "Name" }
				}
			},
			name = { value = "Access", kind = "Name" }
		},
		{
			directives = {},
			kind = "EnumTypeDefinition",
			values = {
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "Phone", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "Email", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "GovernmentId", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "AddedEmail", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "ParentConsent", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "ParentLink", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "AgeEstimation", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "Subscription", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "CardVerification", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "Wait", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "UserAgreement", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "UserSettings", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "Invalid", kind = "Name" }
				}
			},
			name = { value = "RecourseActions", kind = "Name" }
		},
		{
			directives = {},
			kind = "EnumTypeDefinition",
			values = {
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "ChargebackReenableAccount", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "SavePaymentMethods", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "UpdateUserSetting", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "UpdateBirthdate", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "LinkToChild", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "ManageFriend", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "ManageExperience", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "LiftPunishment", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "AddTrustedConnection", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "SendTransfer", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "ReceiveTransfer", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "LiftRestriction", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "Unknown", kind = "Name" }
				}
			},
			name = { value = "VPCRequestTypes", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "featureVector", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "endTime", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "startTime", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Int", kind = "Name" }
					},
					name = { value = "duration", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "vectorTargetID", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "evidence", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "decisionEventID", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Int", kind = "Name" }
					},
					name = { value = "violationType", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Int", kind = "Name" }
					},
					name = { value = "sublabel", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "acknowledgedTime", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "permanent", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "acknowledgeable", kind = "Name" }
				}
			},
			name = { value = "TimeoutActionResponse", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "id", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "displayUrl", kind = "Name" }
				}
			},
			name = { value = "AgreementResponse", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "settingName", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "settingValue", kind = "Name" }
				}
			},
			name = { value = "UserSettingsResponse", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "RecourseActions", kind = "Name" }
					},
					name = { value = "action", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NamedType",
							name = { value = "VPCRequestTypes", kind = "Name" }
						}
					},
					name = { value = "parentConsentTypes", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NamedType",
							name = { value = "TimeoutActionResponse", kind = "Name" }
						}
					},
					name = { value = "timeoutActions", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NamedType",
							name = { value = "AgreementResponse", kind = "Name" }
						}
					},
					name = { value = "agreements", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "UserSettingsResponse", kind = "Name" }
					},
					name = { value = "userSettings", kind = "Name" }
				}
			},
			name = { value = "RecourseResponses", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "featureName", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Access", kind = "Name" }
					},
					name = { value = "access", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NamedType",
							name = { value = "RecourseActions", kind = "Name" }
						}
					},
					name = { value = "recourse", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NamedType",
							name = { value = "RecourseResponses", kind = "Name" }
						}
					},
					name = { value = "recourses", kind = "Name" }
				}
			},
			name = { value = "FeatureAccess", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "FeatureAccess", kind = "Name" }
					},
					name = { value = "featureAccess", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "shouldPrompt", kind = "Name" }
				}
			},
			name = { value = "UpsellFeatureAccessResponse", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NamedType",
							name = { value = "FeatureAccess", kind = "Name" }
						}
					},
					name = { value = "features", kind = "Name" }
				}
			},
			name = { value = "FeatureAccessResponse", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "InterfaceTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ID", kind = "Name" }
						}
					},
					name = { value = "id", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ID", kind = "Name" }
						}
					},
					name = { value = "targetUserId", kind = "Name" }
				}
			},
			name = { value = "Friendship", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {
				{
					kind = "NamedType",
					name = { value = "User", kind = "Name" }
				},
				{
					kind = "NamedType",
					name = { value = "Friendship", kind = "Name" }
				}
			},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ID", kind = "Name" }
						}
					},
					name = { value = "id", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Boolean", kind = "Name" }
					},
					name = { value = "hasVerifiedBadge", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "String", kind = "Name" }
						}
					},
					name = { value = "displayName", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ID", kind = "Name" }
						}
					},
					name = { value = "targetUserId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "UserPresence", kind = "Name" }
					},
					name = { value = "presence", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Float", kind = "Name" }
					},
					name = { value = "sortScore", kind = "Name" }
				}
			},
			name = { value = "Friend", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ID", kind = "Name" }
						}
					},
					name = { value = "targetUserId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "curCursor", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "prevCursor", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "nextCursor", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "ListType",
						type = {
							kind = "NamedType",
							name = { value = "Friend", kind = "Name" }
						}
					},
					name = { value = "friends", kind = "Name" }
				}
			},
			name = { value = "AllFriendsPage", kind = "Name" }
		},
		{
			directives = {},
			kind = "EnumTypeDefinition",
			values = {
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "InGame", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "Online", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "InStudio", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "Offline", kind = "Name" }
				}
			},
			name = { value = "PresenceType", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "InterfaceTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "PresenceType", kind = "Name" }
					},
					name = { value = "userPresenceType", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "lastLocation", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "lastOnline", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "gameId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "placeId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "rootPlaceId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "universeId", kind = "Name" }
				}
			},
			name = { value = "Presence", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {
				{
					kind = "NamedType",
					name = { value = "Presence", kind = "Name" }
				}
			},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ID", kind = "Name" }
						}
					},
					name = { value = "id", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "PresenceType", kind = "Name" }
					},
					name = { value = "userPresenceType", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "lastLocation", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "lastOnline", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "gameId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "placeId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "rootPlaceId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NamedType",
						name = { value = "String", kind = "Name" }
					},
					name = { value = "universeId", kind = "Name" }
				}
			},
			name = { value = "UserPresence", kind = "Name" }
		},
		{
			directives = {},
			kind = "EnumTypeDefinition",
			values = {
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "ExperienceInvite", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "FriendInvite", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "Home", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "Profile", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "NotificationExperienceInvite", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "ScreenshotInvite", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "PrivateServer", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "Server", kind = "Name" }
				},
				{
					directives = {},
					kind = "EnumValueDefinition",
					name = { value = "ExperienceDetails", kind = "Name" }
				}
			},
			name = { value = "ShareLinkType", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {},
			kind = "InterfaceTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ID", kind = "Name" }
						}
					},
					name = { value = "linkId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "String", kind = "Name" }
						}
					},
					name = { value = "shortUrl", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ShareLinkType", kind = "Name" }
						}
					},
					name = { value = "linkType", kind = "Name" }
				}
			},
			name = { value = "ShareLink", kind = "Name" }
		},
		{
			directives = {},
			interfaces = {
				{
					kind = "NamedType",
					name = { value = "ShareLink", kind = "Name" }
				}
			},
			kind = "ObjectTypeDefinition",
			fields = {
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "String", kind = "Name" }
						}
					},
					name = { value = "universeId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ID", kind = "Name" }
						}
					},
					name = { value = "linkId", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "String", kind = "Name" }
						}
					},
					name = { value = "shortUrl", kind = "Name" }
				},
				{
					arguments = {},
					directives = {},
					kind = "FieldDefinition",
					type = {
						kind = "NonNullType",
						type = {
							kind = "NamedType",
							name = { value = "ShareLinkType", kind = "Name" }
						}
					},
					name = { value = "linkType", kind = "Name" }
				}
			},
			name = { value = "ExperienceDetailsLink", kind = "Name" }
		},
		{
			directives = {},
			operationTypes = {
				{
					operation = "mutation",
					kind = "OperationTypeDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Mutation", kind = "Name" }
					}
				},
				{
					operation = "query",
					kind = "OperationTypeDefinition",
					type = {
						kind = "NamedType",
						name = { value = "Query", kind = "Name" }
					}
				}
			},
			kind = "SchemaDefinition"
		}
	},
	kind = "Document"
}
