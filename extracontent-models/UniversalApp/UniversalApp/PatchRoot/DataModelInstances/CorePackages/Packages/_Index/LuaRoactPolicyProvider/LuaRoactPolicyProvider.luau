local connect = require(script.connect)
local Provider = require(script.Provider)
local Logger = require(script.Logger)
local getPolicyImplementations = script.getPolicyImplementations
local fromMemStorageService = require(getPolicyImplementations.fromMemStorageService)
local fromPolicyService = require(getPolicyImplementations.fromPolicyService)
local fromStaticSource = require(getPolicyImplementations.fromStaticSource)
local AppPolicyContext = require(script.AppPolicyContext)

return {
	withGetPolicyImplementation = function(p1) -- line: 12
		-- upvalues: connect (copy), Provider (copy)
		assert(p1.read, "expected getPolicyImpl to have `read` function")
		assert(p1.onPolicyChanged, "expected getPolicyImpl to have `onPolicyChanged` function")

		return {
			connect = connect(p1),
			Provider = Provider()
		}
	end,
	GetPolicyImplementations = {
		MemStorageService = fromMemStorageService(),
		PolicyService = fromPolicyService(),
		Static = fromStaticSource()
	},
	Logger = Logger,
	AppPolicyContext = AppPolicyContext
}
