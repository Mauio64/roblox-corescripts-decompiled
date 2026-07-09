local Parent = script:FindFirstAncestor("BugReporting").Parent
local Dash = require(Parent.Dash)
local React = require(Parent.React)

require(Parent.SystemInfoProtocol)
require(Parent.AppCommonLib)

local BugReporterModal = require(script.Parent.BugReporterModal)
local useBugReporterModalProps = require(script.Parent.useBugReporterModalProps)

require(script.Parent.BugReporterTypes)

local v6 = game:DefineFastInt("InAppBugReporterMinCommentLength", 15)

local function BugReporterModalContainer(t1: {[any]: any}) -- line: 33
	-- upvalues: useBugReporterModalProps (copy), Dash (copy), v6 (copy), React (copy), BugReporterModal (copy)
	local v9 = useBugReporterModalProps(Dash.assign(t1, {
		minCommentLength = v6
	}))

	return React.createElement(BugReporterModal, v9)
end

return BugReporterModalContainer
