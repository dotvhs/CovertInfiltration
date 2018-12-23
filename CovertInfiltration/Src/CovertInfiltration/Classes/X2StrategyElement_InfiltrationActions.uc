// 

class X2StrategyElement_InfiltrationActions extends X2StrategyElement;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> CovertActions;
	
	CovertActions.AddItem(CreatePrepareGOpTemplate());
	CovertActions.AddItem(CreatePrepareRaidTemplate());

	return CovertActions;
}

static function X2DataTemplate CreatePrepareGOpTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_PrepareGOp');

	Template.ChooseLocationFn = class'X2StrategyElement_DefaultCovertActions'.static.ChooseRandomContactedRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.GorillaOps"; // Yes, Firaxis did in fact call it Gorilla Ops
	
	Template.Narratives.AddItem('CovertActionNarrative_PrepareGOp');

	Template.Slots.AddItem(CreateDefaultStaffSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultStaffSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultOptionalSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultOptionalSlot('CovertActionSoldierStaffSlot'));
	
	Template.Rewards.AddItem('Reward_CAGuerillaOp');

	return Template;
}

static function X2DataTemplate CreatePrepareRaidTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_PrepareRaid');

	Template.ChooseLocationFn = class'X2StrategyElement_DefaultCovertActions'.static.ChooseRandomContactedRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";

	Template.Narratives.AddItem('CovertActionNarrative_PrepareRaid');

	Template.Slots.AddItem(CreateDefaultStaffSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultStaffSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultOptionalSlot('CovertActionSoldierStaffSlot'));
	Template.Slots.AddItem(CreateDefaultOptionalSlot('CovertActionSoldierStaffSlot'));

	Template.Rewards.AddItem('Reward_CASupplyRaid');

	return Template;
}

private static function CovertActionSlot CreateDefaultSoldierSlot(name SlotName, optional int iMinRank, optional bool bRandomClass, optional bool bFactionClass)
{
	local CovertActionSlot SoldierSlot;

	SoldierSlot.StaffSlot = SlotName;
	SoldierSlot.Rewards.AddItem('Reward_StatBoostHP');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostAim');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostMobility');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostDodge');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostWill');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostHacking');
	SoldierSlot.Rewards.AddItem('Reward_RankUp');
	SoldierSlot.iMinRank = iMinRank;
	SoldierSlot.bChanceFame = false;
	SoldierSlot.bRandomClass = bRandomClass;
	SoldierSlot.bFactionClass = bFactionClass;

	if (SlotName == 'CovertActionRookieStaffSlot')
	{
		SoldierSlot.bChanceFame = false;
	}

	return SoldierSlot;
}

private static function CovertActionSlot CreateDefaultStaffSlot(name SlotName)
{
	local CovertActionSlot StaffSlot;
	
	// Same as Soldier Slot, but no rewards
	StaffSlot.StaffSlot = SlotName;
	StaffSlot.bReduceRisk = false;
	
	return StaffSlot;
}

private static function CovertActionSlot CreateDefaultOptionalSlot(name SlotName, optional int iMinRank, optional bool bFactionClass)
{
	local CovertActionSlot OptionalSlot;

	OptionalSlot.StaffSlot = SlotName;
	OptionalSlot.bChanceFame = false;
	//OptionalSlot.bReduceRisk = true;
	OptionalSlot.iMinRank = iMinRank;
	OptionalSlot.bFactionClass = bFactionClass;

	return OptionalSlot;
}

private static function StrategyCostReward CreateOptionalCostSlot(name ResourceName, int Quantity)
{
	local StrategyCostReward ActionCost;
	local ArtifactCost Resources;

	Resources.ItemTemplateName = ResourceName;
	Resources.Quantity = Quantity;
	ActionCost.Cost.ResourceCosts.AddItem(Resources);
	ActionCost.Reward = 'Reward_DecreaseRisk';
	
	return ActionCost;
}
