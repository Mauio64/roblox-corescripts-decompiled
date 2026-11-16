local parent = script:FindFirstAncestor("ContactImporter").Parent

local AppCommonLib = require(parent.AppCommonLib)

local status = nil
local statusChanged = AppCommonLib.Signal.new()
local AutoPromptStatus = {}

function AutoPromptStatus.getStatus()
	return status
end

function AutoPromptStatus.setStatus(flag: boolean?)
	status = flag
	statusChanged:fire(flag)
end

AutoPromptStatus.statusChanged = statusChanged
return AutoPromptStatus
