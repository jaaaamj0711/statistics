library(carData)
data <- Prestige
head(data)
str(data)
library(MASS)
data <- subset(data,select =- type)

## ����ȸ�͸���
lm_full <- lm(income ~ ., data=data)
summary(lm_full)

## �����ױ��� ������ ����ȸ�͸���
lm_full_2 <- lm(income ~ .^2, data=data)
summary(lm_full_2)

## ���������� ������ ����ȸ�͸��� (stepwise)
step_both <- stepAIC(lm_full, direction = "both",
                     scope = list(upper = ~ .^2, lower = ~1))
summary(step_both)


## ���������� ������ ����ȸ�͸��� (backward)
step_backward <- stepAIC(lm_full, direction = "backward",
                         scope = list(upper = ~ .^2, lower = ~1))
summary(step_backward)

## ���������� ������ ����ȸ�͸��� (forward)
step_forward <- stepAIC(lm_full, direction = "forward",
                        scope = list(upper = ~ .^2, lower = ~1))


## womenm prestige ���� 2���� ����
lm_w_p <- lm(income~women+prestige+I(women^2)+I(prestige^2), data = data)
step_backward_w_p <- stepAIC(lm_w_p, direction = "both",
                         scope = list(upper = ~ .^2, lower = ~1))

summary(step_backward)


## ��纯�� 2���� ����
lm_2 <- lm(income~.+I(education^2)+I(women^2)+I(prestige^2)+I(census^2), data = data)
# ��� ���� 2���� ���� + stepwise
step_backward_2 <- stepAIC(lm_2, direction = "both",
                         scope = list(upper = ~ .^2, lower = ~1))

summary(step_backward)


# ���� ���� ����
library(rsq)
full.model <- c(rsq(lm_full), rsq(lm_full, adj=TRUE))
full_2.model <- c(rsq(lm_full_2), rsq(lm_full_2, adj=TRUE))
both.model <- c(rsq(step_both), rsq(step_both, adj=TRUE))
backward.model <- c(rsq(step_backward), rsq(step_backward, adj=TRUE))
forward.model <- c(rsq(step_forward), rsq(step_forward, adj=TRUE))
w_p.model <- c(rsq(step_backward_w_p), rsq(step_backward_w_p, adj=TRUE))
lm_2.model <- c(rsq(step_backward_2), rsq(step_backward_2, adj=TRUE))
eval_df <- data.frame(full.model, full_2.model, both.model, backward.model, forward.model, w_p.model, lm_2.model)
names(eval_df) <- c("����ȸ��", "���� ��ȣ�ۿ�", "both", "backward", "forward", "�κ��� ������", "��纯�� ������")
rownames(eval_df) <- c("�������", "������ �������")