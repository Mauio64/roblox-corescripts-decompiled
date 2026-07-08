local CorePackages = game:GetService("CorePackages")
local getClientReplicator = require(script.Parent.Parent.Parent.Util.getClientReplicator)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Actions = script.Parent.Parent.Parent.Actions
local AppendRecentDumpPath = require(Actions.AppendRecentDumpPath)
local SetRCCProfilerState = require(Actions.SetRCCProfilerState)
local v8 = Roact.Component:extend("RCCProfilerDataCompleteListener")

function v8.didMount(p1) -- line: 13
	-- upvalues: getClientReplicator (copy)
	local v12 = getClientReplicator()

	if v12 then
		p1.completeSignal = v12.RCCProfilerDataComplete:Connect(function(p2, p3) -- line: 16
			-- upvalues: p1 (copy)
			if p1.props.waitingForRecording then
				if not p2 then
					warn(p3)
					p1.props.dispatchSetRCCProfilerState(false)

					return
				end

				p1.props.dispatchSetRCCProfilerState(false, p3)
				p1.props.dispatchAppendRecentDumpPath(p3)
			end
		end)
	end
end
function v8.willUnmount(p4) -- line: 30
	if p4.completeSignal then
		p4.completeSignal:Disconnect()
		p4.completeSignal = nil
	end
end
function v8.render(_) -- line: 37
	return nil
end

local function mapStateToProps(p6, _) -- line: 41
	return {
		waitingForRecording = p6.MicroProfiler.waitingForRecording
	}
end
local function mapDispatchToProps(p8) -- line: 47
	-- upvalues: AppendRecentDumpPath (copy), SetRCCProfilerState (copy)
	return {
		dispatchAppendRecentDumpPath = function(s1: string) -- line: 49
			-- upvalues: p8 (copy), AppendRecentDumpPath (copy)
			p8(AppendRecentDumpPath(s1))
		end,
		dispatchSetRCCProfilerState = function(p9, p10) -- line: 52
			-- upvalues: p8 (copy), SetRCCProfilerState (copy)
			p8(SetRCCProfilerState(p9, p10))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(v8)
