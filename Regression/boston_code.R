# ������ �и�
library(MASS)
library(lattice)
data <- Boston
data <- subset(data,select =- chas)
set.seed(1606)
n <- nrow(data)
idx <- 1:n
training_idx <- sample(idx, n * .60)
idx <- setdiff(idx, training_idx)
validate_idx <- sample(idx, n * .20)
test_idx <- setdiff(idx, validate_idx)
training <- data[training_idx,]
validation <- data[validate_idx,]
test <- data[test_idx,]


## ����ȸ�͸���
lm_full <- lm(medv ~ ., data=training)
summary(lm_full)
# ���� ��(training)
hist(lm_full$residuals)
plot(lm_full, which=1)
plot(lm_full, which=2)
  # validation ����
predict_full <- predict(lm_full, newdata = validation)
# ���� ��(validation)
vali_residuals_full<- validation$medv - predict_full
hist(vali_residuals_full)
xyplot(vali_residuals_full~predict_full, type=c('p', 'smooth'),col='black', main= "Residuals vs Fitted")
qqnorm(vali_residuals_full)
qqline(vali_residuals_full, col = "blue") 


## �����ױ��� ������ ����ȸ�͸���
lm_full_2 <- lm(medv ~ .^2, data=training)
summary(lm_full_2)
# ���� �м�(training data)
hist(lm_full_2$residuals)
plot(lm_full_2, which=1)
plot(lm_full_2, which=2)
# validation ����
predict_full_2 <- predict(lm_full_2, newdata = validation)
# ���� ��(validation)
vali_residuals_full_2 <- validation$medv - predict_full_2
hist(vali_residuals_full_2)
xyplot(vali_residuals_full_2~predict_full_2, type=c('p', 'smooth'),col='black', main= "Residuals vs Fitted")
qqnorm(vali_residuals_full_2)
qqline(vali_residuals_full_2, col = "blue")  



## ���������� ������ ����ȸ�͸��� (stepwise)
step_both <- stepAIC(lm_full, direction = "both",
                          scope = list(upper = ~ .^2, lower = ~1))
summary(step_both)
# ���� ��
hist(step_both$residuals)
plot(step_both, which=1)
plot(step_both, which=2)
# validation ����
predict_both <- predict(step_both, newdata = validation)
# ���� ��(validation)
vali_residuals_both <- validation$medv - predict_both
hist(vali_residuals_both)
xyplot(vali_residuals_both~predict_both, type=c('p', 'smooth'),col='black', main= "Residuals vs Fitted")
qqnorm(vali_residuals_both)
qqline(vali_residuals_both, col = "blue") 


## ���������� ������ ����ȸ�͸��� (backward)
step_backward <- stepAIC(lm_full, direction = "backward",
                          scope = list(upper = ~ .^2, lower = ~1))
summary(step_backward)
# ���� ��
hist(step_backward$residuals)
plot(step_backward, which=1)
plot(step_backward, which=2)
# validation ����
predict_backward <- predict(step_backward, newdata = validation)
# ���� ��(validation)
vali_residuals_backward <- validation$medv - predict_backward
hist(vali_residuals_backward)
xyplot(vali_residuals_backward~predict_backward, type=c('p', 'smooth'),col='black', main= "Residuals vs Fitted")
qqnorm(vali_residuals_backward)
qqline(vali_residuals_backward, col = "blue") 


## ���������� ������ ����ȸ�͸��� (forward)
step_forward <- stepAIC(lm_full, direction = "forward",
                             scope = list(upper = ~ .^2, lower = ~1))

summary(step_forward)
# ���� ��
hist(step_forward$residuals)
plot(step_forward, which=1)
plot(step_forward, which=2)
# validation ����
predict_forward <- predict(step_forward, newdata = validation)
# ���� ��(validation)
vali_residuals_forward <- validation$medv - predict_forward
hist(vali_residuals_forward)
xyplot(vali_residuals_forward~predict_forward, type=c('p', 'smooth'),col='black', main= "Residuals vs Fitted")
qqnorm(vali_residuals_forward)
qqline(vali_residuals_forward, col = "blue") 


# RMSE �Լ�
RMSE <- function(actual, predict){
  
  sqrt(mean((actual - predict)^2))
  
}


# ���� �� 
library(rsq)
full.model <- c(length(coef(lm_full)), rsq(lm_full), rsq(lm_full, adj=TRUE), RMSE(training$medv, predict(lm_full)), RMSE(validation$medv, predict_full))
full2.model <- c(length(coef(lm_full_2)), rsq(lm_full_2), rsq(lm_full_2, adj=TRUE), RMSE(training$medv, predict(lm_full_2)), RMSE(validation$medv, predict_full_2))
both.model <- c(length(coef(step_both)), rsq(step_both), rsq(step_both, adj=TRUE), RMSE(training$medv, predict(step_both)), RMSE(validation$medv, predict_both))
backward.model <- c(length(coef(step_backward)), rsq(step_backward), rsq(step_backward, adj=TRUE), RMSE(training$medv, predict(step_backward)), RMSE(validation$medv, predict_backward))
forward.model <- c(length(coef(step_forward)), rsq(step_forward), rsq(step_forward, adj=TRUE), RMSE(training$medv, predict(step_forward)), RMSE(validation$medv, predict_forward))
eval_df <- data.frame(full.model, full2.model,both.model, backward.model, forward.model)
names(eval_df) <- c("����ȸ��", "������ ����ȸ��", "both", "backward", "forward")
rownames(eval_df) <- c("��� ����", "�������", "������ �������", "RMSE �н� ������", "RMSE ���� ������")



