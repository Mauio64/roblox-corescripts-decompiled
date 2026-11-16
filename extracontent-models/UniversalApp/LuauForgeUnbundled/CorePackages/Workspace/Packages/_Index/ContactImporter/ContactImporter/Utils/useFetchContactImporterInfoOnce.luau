local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")

local appStorageService = dependencies.AppStorageService
local useDispatch = dependencies.useDispatch
local useSelector = dependencies.useSelector
local useEffectOnce = dependencies.useEffectOnce
local FetchContactImporterParams = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Networking/FetchContactImporterParams")
local permissionsProtocol = dependencies.PermissionsProtocol
local useContactImporterConfiguration = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Utils/useContactImporterConfiguration")

return function(p2)
	local v5 = useSelector(function(p3)
		return p3.LocalUserId
	end)

	local v6 = useDispatch()

	local function fn()
		v6(FetchContactImporterParams(v5, permissionsProtocol.default, appStorageService))
	end

	local v7 = useContactImporterConfiguration(p2).shouldFetchContactImporterData

	if v7 then
		v7 = if v5 then not (v5 == "") and v5 ~= "0" else v5
	end

	useEffectOnce(fn, v7)
end
