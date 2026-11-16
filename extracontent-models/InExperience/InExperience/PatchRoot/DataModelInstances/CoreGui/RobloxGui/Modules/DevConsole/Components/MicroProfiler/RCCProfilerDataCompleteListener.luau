local CorePackages = game:GetService("CorePackages")
local getClientReplicator = require(script.Parent.Parent.Parent.Util.getClientReplicator)

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local Actions = script.Parent.Parent.Parent.Actions
local AppendRecentDumpPath = require(Actions.AppendRecentDumpPath)
local SetRCCProfilerState = require(Actions.SetRCCProfilerState)

local extended = Roact.Component:extend("RCCProfilerDataCompleteListener")

function extended:didMount()
	local clientReplicator = getClientReplicator()

	if clientReplicator then
		self.completeSignal = clientReplicator.RCCProfilerDataComplete:Connect(function(p, p2)
			if self.props.waitingForRecording then
				if p then
					self.props.dispatchSetRCCProfilerState(false, p2)
					self.props.dispatchAppendRecentDumpPath(p2)
				else
					warn(p2)
					self.props.dispatchSetRCCProfilerState(false)
				end
			end
		end)
	end
end

function extended:willUnmount()
	if self.completeSignal then
		self.completeSignal:Disconnect()
		self.completeSignal = nil
	end
end

function extended.render(_): nil
	return nil
end

local function mapStateToProps(p, _)
	return { waitingForRecording = p.MicroProfiler.waitingForRecording }
end

local function mapDispatchToProps(callback)
	return {
		dispatchAppendRecentDumpPath = function(p: string)
			callback(AppendRecentDumpPath(p))
		end,
		dispatchSetRCCProfilerState = function(p, p2)
			callback(SetRCCProfilerState(p, p2))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(extended)
