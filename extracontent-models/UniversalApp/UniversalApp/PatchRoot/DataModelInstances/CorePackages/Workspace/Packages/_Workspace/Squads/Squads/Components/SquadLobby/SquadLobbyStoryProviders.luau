local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local dependencies = require(Squads.dependencies)
local PresenceType = dependencies.RoduxPresence.Enums.PresenceType
local Roact = dependencies.Roact
local RoactRodux = dependencies.RoactRodux
local Rodux = dependencies.Rodux
local React = dependencies.React
local withDefaults = dependencies.Foundation.Utility.withDefaults
local SquadLocationEnum = require(SquadsParent.SquadsCore.Enums).SquadLocationEnum
local SquadExternalContractProvider = require(SquadsParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractProvider
local makeSquadContract = require(SquadsParent.SquadsCore.SquadExternalContractProvider).makeSquadContract
local CrossExperience = require(SquadsParent.CrossExperience)
local RoactNavigation = require(SquadsParent.RoactNavigation)
local UniversalAppPolicy = require(SquadsParent.UniversalAppPolicy).UniversalAppPolicy
local UserProfiles = require(SquadsParent.UserProfiles)
local Constants = CrossExperience.Constants
local ApolloClient = require(SquadsParent.Dev.ApolloClient)
local GraphQLServer = require(SquadsParent.Dev.GraphQLServer)
local ApolloProvider = ApolloClient.ApolloProvider
local v21 = GraphQLServer.ApolloClientTestUtils.mockApolloClient({})

local function writeNameQuery(s1: string, s2: string) -- line: 31
	-- upvalues: UserProfiles (copy), v21 (copy)
	UserProfiles.Mutations.writeNamesQuery({
		userId = s1,
		client = v21,
		names = {
			alias = s2,
			contactName = s2,
			displayName = s2,
			username = s2,
			platformName = s2
		},
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})
end

writeNameQuery("1111111111", "User 1 has a long name. User 1 has a long name.")
writeNameQuery("2222222222", "User2")
writeNameQuery(tostring(3333333333), "User " .. 3)
writeNameQuery(tostring(4444444444), "User " .. 4)
writeNameQuery(tostring(5555555555), "User " .. 5)
writeNameQuery(tostring(6666666666), "User " .. 6)
writeNameQuery(tostring(7777777777), "User " .. 7)
writeNameQuery(tostring(8888888888), "User " .. 8)
writeNameQuery(tostring(9999999999), "User " .. 9)
writeNameQuery(tostring(11111111110), "User " .. 10)

local t1 = {
	canUsePlatformChat = true,
	children = nil,
	userPresences = {
		["1111111111"] = {
			lastLocation = "Dress to impress",
			placeId = 12345,
			userPresenceType = PresenceType.InGame
		}
	}
}

return function(t2: {[any]: any}) -- line: 69
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), Rodux (copy), Constants (copy), Roact (copy), ApolloProvider (copy), v21 (copy), RoactNavigation (copy), UniversalAppPolicy (copy), RoactRodux (copy), SquadExternalContractProvider (copy), SquadLocationEnum (copy), makeSquadContract (copy)
	local v27 = withDefaults(t2, t1)
	local v28 = React.useMemo(function() -- line: 72
		-- upvalues: Rodux (copy), Constants (copy), v27 (copy)
		return Rodux.Store.new(function() -- line: 73
			-- upvalues: Constants (copy), v27 (copy)
			return {
				LocalUserId = "1111111111",
				ScreenSize = Vector2.new(450, 200),
				Squad = {
					CrossExperienceVoice = {
						Experience = {
							voiceChannelId = "party_12345",
							voiceSessionId = "party_12345_game",
							voiceStatus = Constants.VOICE_STATUS.VOICE_CONNECTED
						},
						Participants = {
							participants = {
								["1111111111"] = {
									userId = "1111111111",
									isMuted = false,
									isSpeaking = false
								}
							},
							activeUserIds = {}
						}
					},
					Presence = {
						byUserId = v27.userPresences
					},
					Squad = {
						currentSquad = {
							squadId = "12345",
							members = {
								[1] = {
									userId = 1111111111
								}
							},
							additionalData = {
								title = "Best friends for life"
							},
							invitees = {
								[1] = {
									userId = 2222222222,
									invitedAtTimestampMs = os.time() * 1000
								}
							}
						}
					},
					NetworkStatus = {},
					UserBlocking = {
						isBlockedByMe = {}
					}
				}
			}
		end, {}, { Rodux.thunkMiddleware })
	end, { v27.userPresences })
	local v29 = React.useMemo(function() -- line: 126
		-- upvalues: v27 (copy)
		return { function() -- line: 128
			-- upvalues: v27 (copy)
			return {
				getCanUsePlatformChat = function() -- line: 130
					-- upvalues: v27 (copy)
					return v27.canUsePlatformChat
				end
			}
		end }
	end, { v27.canUsePlatformChat })

	return Roact.createElement(ApolloProvider, {
		client = v21
	}, {
		navigationProvider = Roact.createElement(RoactNavigation.Provider, {
			value = {
				addListener = function(_) -- line: 143
				end,
				getParam = function(p2) -- line: 144
					return p2
				end,
				getScreenProps = function(_) -- line: 147
					return 0
				end,
				navigate = function(_) -- line: 150
				end,
				pop = function() -- line: 151
				end
			}
		}, {
			policyProvider = Roact.createElement(UniversalAppPolicy.Provider, {
				policy = v29
			}, {
				storeProvider = Roact.createElement(RoactRodux.StoreProvider, {
					store = v28
				}, {
					squadExternalContractProvider = Roact.createElement(SquadExternalContractProvider, {
						squadLocation = SquadLocationEnum.UniversalApp,
						contract = makeSquadContract({
							useParentChannelTitleSelector = function() -- line: 163
								return "Best friends for life"
							end,
							useGetConversationFromId = function() -- line: 166
								return {
									participants = { "2222222222" }
								}
							end
						})
					}, v27.children)
				})
			})
		})
	})
end
