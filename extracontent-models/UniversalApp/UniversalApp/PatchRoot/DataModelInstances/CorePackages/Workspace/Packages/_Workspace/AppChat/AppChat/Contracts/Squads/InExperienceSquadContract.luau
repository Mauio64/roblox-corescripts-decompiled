local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local SocialExperiments = require(AppChatParent.SocialExperiments)
local SquadExternalContractProvider = require(AppChatParent.SquadsCore.SquadExternalContractProvider)
local Enums = require(AppChatParent.SquadsCore.Enums)
local SetSquadPrompt = require(AppChatParent.SquadsCore.Actions).SetSquadPrompt
local CloseSquadPrompt = require(AppChatParent.SquadsCore.Actions).CloseSquadPrompt
local SquadRootViewType = Enums.SquadRootViewType
local makeSquadContract = SquadExternalContractProvider.makeSquadContract
local InExperienceAppChatModal = require(AppChat.App.InExperienceAppChatModal)
local SquadCoordinationExperienceJoinExperimentation = SocialExperiments.SquadCoordinationExperienceJoinExperimentation
local SquadContract = require(script.Parent.SquadContract)

return (makeSquadContract(Cryo.Dictionary.union(SquadContract, {
	setSquadPrompt = function(p1, p2) -- line: 22
		-- upvalues: SetSquadPrompt (copy)
		p1:dispatch(SetSquadPrompt(p2))
	end,
	closeSquadPrompt = CloseSquadPrompt,
	useSquadRootView = function() -- line: 26
		-- upvalues: React (copy), SquadCoordinationExperienceJoinExperimentation (copy), InExperienceAppChatModal (copy), SquadRootViewType (copy)
		local v17, v18 = React.useState(if not SquadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled or not InExperienceAppChatModal.default:getVisible() then SquadRootViewType.None else SquadRootViewType.InExperienceAppChatModal)

		React.useEffect(function() -- line: 33
			-- upvalues: InExperienceAppChatModal (copy), v18 (copy), SquadRootViewType (copy)
			local connection = InExperienceAppChatModal.default.visibilitySignal.Event:Connect(function(p3) -- line: 34
				-- upvalues: v18 (copy), SquadRootViewType (copy)
				if p3 then
					v18(SquadRootViewType.InExperienceAppChatModal)

					return
				end

				v18(SquadRootViewType.None)
			end)

			return function() -- line: 42
				-- upvalues: connection (copy)
				if connection then
					connection:Disconnect()
				end
			end
		end, {})

		return v17
	end
})))
