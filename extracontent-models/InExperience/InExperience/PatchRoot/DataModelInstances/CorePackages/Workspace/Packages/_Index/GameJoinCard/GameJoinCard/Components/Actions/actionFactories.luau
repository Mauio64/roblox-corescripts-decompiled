local JoinExperienceAction = require(script.Parent.JoinExperienceAction)
local PlayExperienceAction = require(script.Parent.PlayExperienceAction)
local ChatAction = require(script.Parent.ChatAction)
local ViewProfileAction = require(script.Parent.ViewProfileAction)
local UnlockExperienceAction = require(script.Parent.UnlockExperienceAction)

require(script.Parent.Types)

local ActionFactories = {}

for _, v in {
	JoinExperienceAction,
	PlayExperienceAction,
	ChatAction,
	ViewProfileAction,
	UnlockExperienceAction
} do
	for k, v2 in v do
		assert(ActionFactories[k] == nil, "Duplicate GameJoinCard action key: " .. tostring(k))
		ActionFactories[k] = v2
	end
end

return ActionFactories
