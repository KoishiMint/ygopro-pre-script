--転生炎獣フォクサー
--Salamangreat Foxer
--scripted by Larry126
function c101007005.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101007005,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101007005)
	e1:SetCondition(c101007005.condition)
	e1:SetCost(c101007005.cost)
	e1:SetTarget(c101007005.target)
	e1:SetOperation(c101007005.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101007005,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101007005)
	e2:SetCondition(c101007005.spcon)
	e2:SetTarget(c101007005.sptg)
	e2:SetOperation(c101007005.spop)
	c:RegisterEffect(e2)
end
function c101007005.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x119)
end
function c101007005.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101007005.cfilter,tp,LOCATION_GRAVE,0,3,nil)
end
function c101007005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101007005.filter(c)
	return c:GetSequence()<5
end
function c101007005.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x119) and c:IsType(TYPE_LINK) and c:IsAbleToExtra()
end
function c101007005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101007005.filter,tp,0,LOCATION_SZONE,1,nil)
		and Duel.IsExistingTarget(c101007005.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local lg=Duel.SelectTarget(tp,c101007005.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c101007005.filter,tp,0,LOCATION_SZONE,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,1-tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,lg,1,tp,LOCATION_GRAVE) 
end
function c101007005.operation(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local lc=g:GetFirst()
	if lc==sc then lc=g:GetNext() end
	if lc and lc:IsRelateToEffect(e) and Duel.SendtoDeck(lc,nil,2,REASON_EFFECT)>0 and sc and sc:IsRelateToEffect(e) then
		Duel.Destroy(sc,REASON_EFFECT)
	end
end
function c101007005.spfilter(c,tp)
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_SZONE)
		and c:GetPreviousControler()==1-tp and c:GetPreviousSequence()<5
end
function c101007005.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101007005.spfilter,1,nil,tp)
end
function c101007005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c101007005.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
