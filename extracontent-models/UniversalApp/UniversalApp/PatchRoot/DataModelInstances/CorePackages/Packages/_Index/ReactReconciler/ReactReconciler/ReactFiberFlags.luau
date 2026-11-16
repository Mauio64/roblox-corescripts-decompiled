local Shared = require(script.Parent.Parent.Shared)

local ReactFiberFlags = {
	NoFlags = 0,
	PerformedWork = 1,
	Placement = 2,
	Update = 4,
	PlacementAndUpdate = 6,
	Deletion = 8,
	ContentReset = 16,
	Callback = 32,
	DidCapture = 64,
	Ref = 128,
	Snapshot = 256,
	Passive = 512,
	PassiveUnmountPendingDev = 8192,
	Hydrating = 1024,
	HydratingAndUpdate = 1028,
	HostUpdate = 262144,
	LifecycleEffectMask = 932,
	HostEffectMask = 2047,
	Incomplete = 2048,
	ShouldCapture = 4096,
	ForceUpdateForLegacySuspense = 16384,
	PassiveStatic = 32768
}

if Shared.ReactFeatureFlags.enableCommitTraversalTrims then
	ReactFiberFlags.BeforeMutationMask = 266
	ReactFiberFlags.MutationMask = 263326
else
	ReactFiberFlags.BeforeMutationMask = 778

	ReactFiberFlags.MutationMask = 1182
end

ReactFiberFlags.LayoutMask = 164

ReactFiberFlags.PassiveMask = 520

ReactFiberFlags.StaticMask = 32768

ReactFiberFlags.MountLayoutDev = 65536

ReactFiberFlags.MountPassiveDev = 131072

return ReactFiberFlags
