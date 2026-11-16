local function linkAction(bindingPath: string)
	return {
		value = {
			linkAction = {
				actionType = "ACTION_TYPE_LINK",
				actionParams = {
					url = { bindingPath = bindingPath },
					titleKey = { literal = "CommonUI.Features.Label.Groups" }
				}
			}
		}
	}
end

local function textItem(identifier: string, props)
	return {
		identifier = identifier,
		inlineComponent = {
			text = {
				props = props,
				shared = { componentType = "UI_COMPONENT_TYPE_TEXT" }
			}
		}
	}
end

local function viewItem(identifier: string, props)
	return {
		identifier = identifier,
		inlineComponent = {
			view = {
				props = props,
				shared = { componentType = "UI_COMPONENT_TYPE_VIEW" }
			}
		}
	}
end

local function literalList(items)
	return {
		componentList = {
			literal = { items = items }
		}
	}
end

local function post(p: number, creatorUserId: string, creatorRoleName: string?, replyCount: number, postUrl: string)
	return {
		postId = `post-{p}`,
		postShortId = `p{p}`,
		categoryId = "category-1",
		categoryShortId = "c1",
		categoryName = "General",
		title = `Post title {p}`,
		body = `Post **body** {p}`,
		creatorKey = `User_{creatorUserId}`,
		creatorUserId = creatorUserId,
		creatorRoleName = creatorRoleName,
		replyCount = replyCount,
		postUrl = postUrl
	}
end

return {
	pageEntries = {
		{
			pageEntry = {
				robloxComponent = "GroupForumsDiscovery",
				identifier = "groupForumsDiscovery",
				title = "",
				category = ""
			},
			inputData = {
				groupForumsDiscovery = {
					groupId = "151432314",
					seeAllUrl = "https://www.roblox.com/communities/151432314#!/forums",
					posts = {
						post(
							1,
							"7017120594",
							"Top Panda",
							3,
							"https://www.roblox.com/communities/151432314#!/forums/general-c1/post/hello-world-p1"
						),
						post(
							2,
							"42",
							nil,
							0,
							"https://www.roblox.com/communities/151432314#!/forums/general-c1/post/second-post-p2"
						)
					}
				}
			}
		}
	},
	hydrationData = {
		creator = {
			User_7017120594 = {
				creatorType = "User",
				creatorId = "7017120594",
				creatorName = "BuilderSaiyanSage",
				isVerified = true
			},
			User_42 = {
				creatorType = "User",
				creatorId = "42",
				creatorName = "Poster",
				isVerified = false
			}
		}
	},
	templates = {
		["group-forums-discovery-test"] = {
			robloxComponent = "GroupForumsDiscovery",
			template = {
				view = {
					props = {
						tag = { literal = "col gap-medium size-full-0 auto-y" },
						children = literalList({
							viewItem("header", {
								tag = {
									literal = "row align-y-center gap-small size-full-0 auto-y"
								},
								layoutOrder = { literal = 1 },
								children = literalList({
									textItem("title", {
										text = {
											translation = {
												namespace = "Feature.Groups",
												key = "Heading.GroupForumsTopPosts",
												mapKey = "feature-groups-heading-group-forums-top-posts"
											}
										},
										tag = {
											literal = "auto-xy text-heading-medium text-align-x-left content-default"
										},
										layoutOrder = { literal = 1 }
									}),
									textItem("see_all", {
										text = {
											translation = {
												namespace = "Feature.Groups",
												key = "Action.SeeAll",
												mapKey = "feature-groups-action-see-all"
											}
										},
										tag = {
											literal = "auto-xy text-body-medium text-align-x-right content-emphasis"
										},
										layoutOrder = { literal = 2 },
										onActivated = linkAction("see_all_url")
									})
								})
							}),
							viewItem("posts", {
								tag = { literal = "col gap-small size-full-0 auto-y" },
								layoutOrder = { literal = 2 },
								children = {
									componentList = {
										bindingPath = "posts",
										defaultItem = {
											robloxComponent = "GroupForumPostPreviewItem"
										}
									}
								}
							})
						})
					},
					shared = { componentType = "UI_COMPONENT_TYPE_VIEW" }
				}
			}
		},
		["group-forum-post-preview-item-test"] = {
			robloxComponent = "GroupForumPostPreviewItem",
			template = {
				groupForumPostPreview = {
					props = {
						title = { bindingPath = "title" },
						body = { bindingPath = "body" },
						creatorUserId = { bindingPath = "creator_user_id" },
						creatorDisplayName = { bindingPath = "c.creator_name" },
						creatorIsVerified = { bindingPath = "c.is_verified" },
						creatorRoleName = { bindingPath = "creator_role_name" },
						replyCount = { bindingPath = "reply_count" },
						onActivated = linkAction("post_url")
					},
					shared = {
						componentType = "UI_COMPONENT_TYPE_GROUP_FORUM_POST_PREVIEW",
						data = {
							{
								contentType = "HYDRATION_CONTENT_TYPE_CREATOR",
								idBinding = { inputPath = "creator_key" },
								alias = "c"
							}
						}
					}
				}
			}
		}
	},
	localizedLiterals = {
		["feature-groups-heading-group-forums-top-posts"] = "Top Posts",
		["feature-groups-action-see-all"] = "See All"
	}
}
