local connect = require(script.connect)
local Provider = require(script.Provider)
local Logger = require(script.Logger)

local getPolicyImplementations = script.getPolicyImplementations
local fromMemStorageService = require(getPolicyImplementations.fromMemStorageService)
local fromPolicyService = require(getPolicyImplementations.fromPolicyService)
local fromStaticSource = require(getPolicyImplementations.fromStaticSource)
local AppPolicyContext = require(script.AppPolicyContext)

return {
	withGetPolicyImplementation = function(p)
		assert(p.read, "expected getPolicyImpl to have `read` function")
		assert(p.onPolicyChanged, "expected getPolicyImpl to have `onPolicyChanged` function")
		return { connect = connect(p), Provider = Provider() }
	end,
	GetPolicyImplementations = {
		MemStorageService = fromMemStorageService(),
		PolicyService = fromPolicyService(),
		Static = fromStaticSource()
	},
	Logger = Logger,
	AppPolicyContext = AppPolicyContext
}
