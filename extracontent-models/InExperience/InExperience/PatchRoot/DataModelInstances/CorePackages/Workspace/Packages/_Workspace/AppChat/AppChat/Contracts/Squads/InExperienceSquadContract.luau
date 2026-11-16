local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local SocialExperiments = require(parent.SocialExperiments)
local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local Enums = require(parent.SquadsCore.Enums)

local Actions = require(parent.SquadsCore.Actions)
local SetSquadPrompt = Actions.SetSquadPrompt
local Actions2 = require(parent.SquadsCore.Actions)
local CloseSquadPrompt = Actions2.CloseSquadPrompt

local SquadRootViewType = Enums.SquadRootViewType
local makeSquadContract = SquadExternalContractProvider.makeSquadContract

local InExperienceAppChatModal = require(AppChat.App.InExperienceAppChatModal)

local SquadCoordinationExperienceJoinExperimentation = SocialExperiments.SquadCoordinationExperienceJoinExperimentation

local SquadContract = require(script.Parent.SquadContract)

return (makeSquadContract(Cryo.Dictionary.union(SquadContract, {
	setSquadPrompt = function(object, p)
		object:dispatch(SetSquadPrompt(p))
	end,
	closeSquadPrompt = CloseSquadPrompt,
	useSquadRootView = function()
		local useState = React.useState
		local v

		if
			SquadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled
			and InExperienceAppChatModal.default:getVisible()
		then
			v = SquadRootViewType.InExperienceAppChatModal
		else
			v = SquadRootViewType.None
		end

		local state, setState = useState(v)

		React.useEffect(function()
			local eventConnection = InExperienceAppChatModal.default.visibilitySignal.Event:Connect(function(p)
				if p then
					setState(SquadRootViewType.InExperienceAppChatModal)
				else
					setState(SquadRootViewType.None)
				end
			end)

			return function()
				if eventConnection then
					eventConnection:Disconnect()
				end
			end
		end, {})

		return state
	end
})))
