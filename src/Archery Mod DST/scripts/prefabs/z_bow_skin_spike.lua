local assets = ARCHERYFUNCS.GenerateSkinAssets("z_bow_skin_spike")

return CreatePrefabSkin("z_bow_skin_spike",
{
	base_prefab = "bow",
	type = "item",
	assets = assets,
	build_name = "swap_z_bow_skin_spike",
	rarity = "Elegant",
	init_fn = function(inst) end,
})