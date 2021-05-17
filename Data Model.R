library(dplyr)
library(ggplot2)
library(mosaic)
library(car)


data <- read.csv('Financial Product Preference Form.csv')

### -------------------- CLEAN DATA -------------------- ###

# Remove timestamp column
data$Timestamp <- NULL

# Rename columns
names(data) = c('sex', 'age', 'status', 'pay.cycle', 
                'income', 'expense', 'net.income', 'risk.appetite', 
                'saving.minimum.deposit', 'saving.additional.fees', 'saving.time.period', 'saving.interest.rate', 'saving.risk', 
                'loan.minimum.deposit', 'loan.additional.fees', 'loan.time.period', 'loan.interest.rate', 'loan.risk', 
                'investment.minimum.deposit', 'investment.additional.fees', 'investment.time.period', 'investment.interest.rate', 'investment.risk', 
                'saving.preference', 'loan.preference', 'investment.preference')


# Respondents typed varying responses to indicate that they had no pay cycle. Survey should have been better structured to account for this.
# We must group these varying responses into one response
data[data$pay.cycle != 'Bi-weekly' & data$pay.cycle != 'Weekly' & data$pay.cycle != 'Semi-monthly' & data$pay.cycle != 'Monthly', 'pay.cycle'] <- 'None'

# Google Forms includes the labels in the responses on linear scales at the extremes so those had to be removed
data[data$saving.minimum.deposit == '1 (Not important)', 'saving.minimum.deposit'] <- '1'
data[data$saving.minimum.deposit == '5 (Very important)', 'saving.minimum.deposit'] <- '5'

data[data$saving.additional.fees == '1 (Not important)', 'saving.additional.fees'] <- '1'
data[data$saving.additional.fees == '5 (Very important)', 'saving.additional.fees'] <- '5'

data[data$saving.time.period == '1 (Not important)', 'saving.time.period'] <- '1'
data[data$saving.time.period == '5 (Very important)', 'saving.time.period'] <- '5'

data[data$saving.interest.rate == '1 (Not important)', 'saving.interest.rate'] <- '1'
data[data$saving.interest.rate == '5 (Very important)', 'saving.interest.rate'] <- '5'

data[data$saving.risk == '1 (Not important)', 'saving.risk'] <- '1'
data[data$saving.risk == '5 (Very important)', 'saving.risk'] <- '5'


data[data$loan.minimum.deposit == '1 (Not important)', 'loan.minimum.deposit'] <- '1'
data[data$loan.minimum.deposit == '5 (Very important)', 'loan.minimum.deposit'] <- '5'

data[data$loan.additional.fees == '1 (Not important)', 'loan.additional.fees'] <- '1'
data[data$loan.additional.fees == '5 (Very important)', 'loan.additional.fees'] <- '5'

data[data$loan.time.period == '1 (Not important)', 'loan.time.period'] <- '1'
data[data$loan.time.period == '5 (Very important)', 'loan.time.period'] <- '5'

data[data$loan.interest.rate == '1 (Not important)', 'loan.interest.rate'] <- '1'
data[data$loan.interest.rate == '5 (Very important)', 'loan.interest.rate'] <- '5'

data[data$loan.risk == '1 (Not important)', 'loan.risk'] <- '1'
data[data$loan.risk == '5 (Very important)', 'loan.risk'] <- '5'


data[data$investment.minimum.deposit == '1 (Not important)', 'investment.minimum.deposit'] <- '1'
data[data$investment.minimum.deposit == '5 (Very important)', 'investment.minimum.deposit'] <- '5'

data[data$investment.additional.fees == '1 (Not important)', 'investment.additional.fees'] <- '1'
data[data$investment.additional.fees == '5 (Very important)', 'investment.additional.fees'] <- '5'

data[data$investment.time.period == '1 (Not important)', 'investment.time.period'] <- '1'
data[data$investment.time.period == '5 (Very important)', 'investment.time.period'] <- '5'

data[data$investment.interest.rate == '1 (Not important)', 'investment.interest.rate'] <- '1'
data[data$investment.interest.rate == '5 (Very important)', 'investment.interest.rate'] <- '5'

data[data$investment.risk == '1 (Not important)', 'investment.risk'] <- '1'
data[data$investment.risk == '5 (Very important)', 'investment.risk'] <- '5'


# Removing outliers - we only have one observation of each of these
data <- data[data$age != '56 - 65',]
data <- data[data$sex != 'Prefer not to say',]



### -------------------- FORMAT DATA -------------------- ###

data$sex <- as.factor(data$sex)
data[, 'age'] <- ordered(data$age, levels = c('18 - 25', '26 - 35', '36 - 45', '46 - 55', '56 - 65'))
data[, 'age'] <- ordered(data$age, levels = c('18 - 25', '26 - 35', '36 - 45', '46 - 55'))
data$status <- as.factor(data$status) # Not sure if this is the best way to deal with statuses since people can have more than one
data[, 'pay.cycle'] <- ordered(data$pay.cycle, levels = c('None', 'Weekly', 'Bi-weekly', 'Semi-monthly', 'Monthly'))
data[, 'income'] <- ordered(data$income, levels = c('$0', '$1 to $500,000', '$500,000 to $1,500,000', '$1,500,000 to $2,500,000', '$2,500,000 to $3,500,000', '$3,500,000 to $4,500,000', '$4,500,000 to $5,500,000', '$5,500,000 and greater'))
data[, 'expense'] <- ordered(data$expense, levels = c('$0 to $20,000', '$20,000 to $60,000', '$60,000 to $100,000', '$100,000 to $140,000', '$140,000 to $180,000', '$180,000 to $220,000', '$220,000 to $260,000', '$260,000 to $300,000', '$300,000 and greater'))
data[, 'net.income'] <- ordered(data$net.income, levels = c('$0 to $20,000', '$20,000 to $60,000', '$60,000 to $100,000', '$100,000 to $140,000', '$140,000 to $180,000', '$180,000 to $220,000', '$220,000 to $260,000', '$260,000 to $300,000', '$300,000 and greater'))

data$saving.minimum.deposit <- as.numeric(data$saving.minimum.deposit)
data$saving.additional.fees <- as.numeric(data$saving.additional.fees)
data$saving.time.period <- as.numeric(data$saving.time.period)
data$saving.interest.rate <- as.numeric(data$saving.interest.rate)
data$saving.risk <- as.numeric(data$saving.risk)

data$loan.minimum.deposit <- as.numeric(data$loan.minimum.deposit)
data$loan.additional.fees <- as.numeric(data$loan.additional.fees)
data$loan.time.period <- as.numeric(data$loan.time.period)
data$loan.interest.rate <- as.numeric(data$loan.interest.rate)
data$loan.risk <- as.numeric(data$loan.risk)

data$investment.minimum.deposit <- as.numeric(data$investment.minimum.deposit)
data$investment.additional.fees <- as.numeric(data$investment.additional.fees)
data$investment.time.period <- as.numeric(data$investment.time.period)
data$investment.interest.rate <- as.numeric(data$investment.interest.rate)
data$investment.risk <- as.numeric(data$investment.risk)



# levels(data$age)[levels(data$age) == '18 - 25'] <- 'A' 
# levels(data$age)[levels(data$age) == '26 - 35'] <- 'B'
# levels(data$age)[levels(data$age) == '36 - 45'] <- 'C'
# levels(data$age)[levels(data$age) == '46 - 55'] <- 'D'
# levels(data$age)[levels(data$age) == '56 - 65'] <- 'E'
# 
# 
# levels(data$income)[levels(data$income) == '$0'] <- 'A' 
# levels(data$income)[levels(data$income) == '$1 to $500,000'] <- 'B'
# levels(data$income)[levels(data$income) == '$500,000 to $1,500,000'] <- 'C'
# levels(data$income)[levels(data$income) == '$1,500,000 to $2,500,000'] <- 'D'
# levels(data$income)[levels(data$income) == '$2,500,000 to $3,500,000'] <- 'E'
# levels(data$income)[levels(data$income) == '$3,500,000 to $4,500,000'] <- 'F'
# levels(data$income)[levels(data$income) == '$4,500,000 to $5,500,000'] <- 'G'
# levels(data$income)[levels(data$income) == '$5,500,000 and greater'] <- 'H'
# 
# 
# levels(data$expense)[levels(data$expense) == '$0 to $20,000'] <- 'A' 
# levels(data$expense)[levels(data$expense) == '$20,000 to $60,000'] <- 'B'
# levels(data$expense)[levels(data$expense) == '$60,000 to $100,000'] <- 'C'
# levels(data$expense)[levels(data$expense) == '$100,000 to $140,000'] <- 'D'
# levels(data$expense)[levels(data$expense) == '$140,000 to $180,000'] <- 'E'
# levels(data$expense)[levels(data$expense) == '$180,000 to $220,000'] <- 'F'
# levels(data$expense)[levels(data$expense) == '$220,000 to $260,000'] <- 'G'
# levels(data$expense)[levels(data$expense) == '$260,000 to $300,000'] <- 'H'
# levels(data$expense)[levels(data$expense) == '$300,000 and greater'] <- 'I'
# 
# 
# levels(data$net.income)[levels(data$net.income) == '$0 to $20,000'] <- 'A' 
# levels(data$net.income)[levels(data$net.income) == '$20,000 to $60,000'] <- 'B'
# levels(data$net.income)[levels(data$net.income) == '$60,000 to $100,000'] <- 'C'
# levels(data$net.income)[levels(data$net.income) == '$100,000 to $140,000'] <- 'D'
# levels(data$net.income)[levels(data$net.income) == '$140,000 to $180,000'] <- 'E'
# levels(data$net.income)[levels(data$net.income) == '$180,000 to $220,000'] <- 'F'
# levels(data$net.income)[levels(data$net.income) == '$220,000 to $260,000'] <- 'G'
# levels(data$net.income)[levels(data$net.income) == '$260,000 to $300,000'] <- 'H'
# levels(data$net.income)[levels(data$net.income) == '$300,000 and greater'] <- 'I'



### -------------------- EXPLORE DATA -------------------- ###
str(data)
summary(data)


# Shows how income changes with age
ggplot(data, aes(x = age, fill = income)) +
  geom_bar() +
  theme_bw() +
  labs(title = 'Distribution of Income Levels at each Age', x = 'Age', y = 'Count', fill = 'Income')

# Shows how expense changes with age
ggplot(data, aes(x = age, fill = expense)) +
  geom_bar() +
  theme_bw() +
  labs(title = 'Distribution of Expense Levels at each Age', x = 'Age', y = 'Count', fill = 'Expense')

# Shows how net income changes with age
ggplot(data, aes(x = age, fill = net.income)) +
  geom_bar() +
  theme_bw() +
  labs(title = 'Distribution of Net Income Levels at each Age', x = 'Age', y = 'Count', fill = 'Net Income')

# Shows how risk appetite changes with age
ggplot(data, aes(x = age, y = risk.appetite, color = age)) +
  geom_boxplot(show.legend = FALSE) +
  geom_jitter(show.legend = FALSE) +
  theme_bw() +
  labs(title = 'Distribution of Risk Appetite at each Age', x = 'Age', y = 'Risk Appetite') +
  coord_flip()


# Exploring if the user's ranking of importance of saving products attributes had any effect on their preference for saving products
ggplot(data, aes(x = saving.minimum.deposit, y = saving.preference)) +
  geom_point() +
  stat_smooth() +
  theme_bw() +
  labs(title = 'Saving Minimum Deposit vs Saving Preference', x = 'Saving Minimum Deposit Importance', y = 'Saving Preference')

ggplot(data, aes(x = saving.time.period, y = saving.preference)) +
  geom_point() +
  stat_smooth() +
  theme_bw() +
  labs(title = 'Saving Time Period vs Saving Preference', x = 'Saving Time Period Importance', y = 'Saving Preference')

ggplot(data, aes(x = saving.interest.rate, y = saving.preference)) +
  geom_point() +
  stat_smooth() +
  theme_bw() +
  labs(title = 'Saving Interest Rate vs Saving Preference', x = 'Saving Interest Rate Importance', y = 'Saving Preference')

ggplot(data, aes(x = saving.additional.fees, y = saving.preference)) +
  geom_point() +
  stat_smooth() +
  theme_bw() +
  labs(title = 'Saving Additional Fees vs Saving Preference', x = 'Saving Additional Fees Importance', y = 'Saving Preference')

ggplot(data, aes(x = saving.risk, y = saving.preference)) +
  geom_point() +
  stat_smooth() +
  theme_bw() +
  labs(title = 'Saving Risk vs Saving Preference', x = 'Saving Risk Importance', y = 'Saving Preference')


# Exploring if the user's ranking of loan products attributes had any effect on their preference for loan products
ggplot(data, aes(x = loan.minimum.deposit, y = loan.preference)) +
  geom_point() +
  stat_smooth() +
  theme_bw() +
  labs(title = 'Loan Minimum Deposit vs Loan Preference', x = 'Loan Minimum Deposit Importance', y = 'Loan Preference')

ggplot(data, aes(x = loan.time.period, y = loan.preference)) +
  geom_point() +
  stat_smooth() +
  theme_bw() +
  labs(title = 'Loan Time Period vs Loan Preference', x = 'Loan Time Period Importance', y = 'Loan Preference')

ggplot(data, aes(x = loan.interest.rate, y = loan.preference)) +
  geom_point() +
  stat_smooth() +
  theme_bw() +
  labs(title = 'Loan Interest Rate vs Loan Preference', x = 'Loan Interest Rate Importance', y = 'Loan Preference')

ggplot(data, aes(x = loan.additional.fees, y = loan.preference)) +
  geom_point() +
  stat_smooth() +
  theme_bw() +
  labs(title = 'Loan Additional Fees vs Loan Preference', x = 'Loan Additional Fees Importance', y = 'Loan Preference')

ggplot(data, aes(x = loan.risk, y = loan.preference)) +
  geom_point() +
  stat_smooth() +
  theme_bw() +
  labs(title = 'Loan Risk vs Loan Preference', x = 'Loan Risk Importance', y = 'Loan Preference')


# Exploring if the user's ranking of investment products attributes had any effect on their preference for investment products
ggplot(data, aes(x = investment.minimum.deposit, y = investment.preference)) +
  geom_point() +
  stat_smooth() +
  theme_bw() +
  labs(title = 'Investment Minimum Deposit vs Investment Preference', x = 'Investment Minimum Deposit Importance', y = 'Investment Preference')

ggplot(data, aes(x = investment.time.period, y = investment.preference)) +
  geom_point() +
  stat_smooth() +
  theme_bw() +
  labs(title = 'Investment Time Period vs Investment Preference', x = 'Investment Time Period Importance', y = 'Investment Preference')


ggplot(data, aes(x = investment.interest.rate, y = investment.preference)) +
  geom_point() +
  stat_smooth() +
  theme_bw() +
  labs(title = 'Investment Interest Rate vs Investment Preference', x = 'Investment Interest Rate Importance', y = 'Investment Preference')

ggplot(data, aes(x = investment.additional.fees, y = investment.preference)) +
  geom_point() +
  stat_smooth() +
  theme_bw() +
  labs(title = 'Investment Additional Fees vs Investment Preference', x = 'Investment Additional Fees Importance', y = 'Investment Preference')

ggplot(data, aes(x = investment.risk, y = investment.preference)) +
  geom_point() +
  stat_smooth() +
  theme_bw() +
  labs(title = 'Investment Risk vs Investment Preference', x = 'Investment Risk Importance', y = 'Investment Preference')



# Exploring if a user's risk appetite is correlated to their preference for saving, loan or investment
cor.test(data$risk.appetite, data$saving.preference) # Very weak negative correlation, very high p-value
cor.test(data$risk.appetite, data$loan.preference) # Very weak negative correlation, very high p-value
cor.test(data$risk.appetite, data$investment.preference) # Some positive correlation, very low p-value



### -------------------- CREATING DATA MODEL -------------------- ###

# Split data into training and testing
set.seed(29) # 3, 11
train <- sample(1:nrow(data), nrow(data)*0.8)
training.data <- data[train, ]
testing.data <- data[-train, ] # ISSUE: Depending on the seed, the training or testing dataset may not have an age or pay.cycle factor present and then R thinks we're trying to introduce another factor when predicting


# *** Building the models ***
# Saving model
saving.model <- lm(saving.preference ~ sex + age + status + pay.cycle + income + expense + net.income + risk.appetite, data = training.data) # + saving.minimum.deposit + saving.additional.fees + saving.time.period + saving.interest.rate + saving.risk, data = training.data)
summary(saving.model)
Anova(saving.model) # net.income and status explanatory variables are barely statistically significant

saving.model <- lm(saving.preference ~ status + net.income, data = training.data)
summary(saving.model) # R^2 still very low and p-value still very high. Not good
Anova(saving.model)


# Loan model
loan.model <- lm(loan.preference ~ sex + age + status + pay.cycle + income + expense + net.income + risk.appetite, data = training.data) # + loan.minimum.deposit + loan.additional.fees + loan.time.period + loan.interest.rate + loan.risk, data = training.data)
summary(loan.model)
Anova(loan.model) # status and risk.appetite explanatory variables are barely statistically significant

loan.model <- lm(loan.preference ~ status + income + net.income + risk.appetite, data = training.data)
summary(loan.model)
Anova(loan.model) # All explanatory variables are somewhat significant


# Investment model
investment.model <- lm(investment.preference ~ sex + age + status + pay.cycle + income + expense + net.income + risk.appetite, data = training.data) # + investment.minimum.deposit + investment.additional.fees + investment.time.period + investment.interest.rate + investment.risk, data = training.data)
summary(investment.model)
Anova(investment.model) # All explanatory variables aren't statistically significant but this is the best R^2 and p-value model

# investment.model <- lm(investment.preference ~ sex + income + net.income + risk.appetite, data = training.data)
# summary(investment.model)
# Anova(investment.model) # net.income no longer statistically significant
# 
# 
# investment.model <- lm(investment.preference ~ sex + income + risk.appetite, data = training.data)
# summary(investment.model)
# Anova(investment.model) # All explanatory variables are somewhat significant



# *** Using the models for predictions ***
# Saving predictions
predict(saving.model, testing.data[, 1:8])
testing.data$saving.predicted <- as.integer(predict(saving.model, testing.data[,1:8]))


# Loan predictions
predict(loan.model, testing.data[, 1:8])
testing.data$loan.predicted <- as.integer(predict(loan.model, testing.data[,1:8]))


# Investment predictions
predict(investment.model, testing.data[, 1:8])
testing.data$investment.predicted <- as.integer(predict(investment.model, testing.data[,1:8]))



# *** Determining the accuracy of each model *** 
sum(ifelse(abs(testing.data$saving.preference - testing.data$predicted) < 1, 1, 0))/nrow(testing.data) * 100
sum(ifelse(abs(testing.data$loan.preference - testing.data$predicted) < 1, 1, 0))/nrow(testing.data) * 100
sum(ifelse(abs(testing.data$investment.preference - testing.data$predicted) < 1, 1, 0))/nrow(testing.data) * 100




# # FINDING WHICH VARIABLES ARE SIGNIFICANT
# # risk.model <- lm(risk.appetite ~ sex + age + status + pay.cycle + income + expense + net.income, data = data)
# # summary(risk.model)
# 
# 
# 
# 
# 
# 
# 
# new_data <- data
# new_data$sex_m <- ifelse(data$sex == 'Male', 1, 0)
# new_data$sex_f <- ifelse(data$sex == 'Female', 1, 0)
# new_data$sex <- NULL
# 
# 
# new_data$age_18_25 <- ifelse(data$age == '18 - 25', 1, 0)
# new_data$age_26_35 <- ifelse(data$age == '26 - 35', 1, 0)
# new_data$age_36_45 <- ifelse(data$age == '36 - 45', 1, 0)
# new_data$age_46_55 <- ifelse(data$age == '46 - 55', 1, 0)
# new_data$age <- NULL
# 
# 
# new_data$status_fe <- ifelse((grepl('Full-time employed', data$status)), 1, 0)
# new_data$status_pe <- ifelse((grepl('Part-time employed', data$status)), 1, 0)
# new_data$status_ne <- ifelse((grepl('Not employed for pay', data$status)), 1, 0)
# new_data$status_cg <- ifelse((grepl('Caregiver', data$status)), 1, 0)
# # new_data$status_hm <- ifelse((grepl('Homemaker', data$status)), 1, 0)
# new_data$status_fs <- ifelse((grepl('Full-time student', data$status)), 1, 0)
# new_data$status_ps <- ifelse((grepl('Part-time student', data$status)), 1, 0)
# new_data$status <- NULL
# 
# 
# new_data$pay_weekly <- ifelse(data$pay.cycle == 'Weekly', 1, 0)
# new_data$pay_bi_weekly <- ifelse(data$pay.cycle == 'Bi-weekly', 1, 0)
# new_data$pay_semi_monthly <- ifelse(data$pay.cycle == 'Semi-monthly', 1, 0)
# new_data$pay_monthly <- ifelse(data$pay.cycle == 'Monthly', 1, 0)
# new_data$pay.cycle <- NULL
# 
# 
# new_data$income_0 <- ifelse(data$income == '$0', 1, 0)
# new_data$income_500 <- ifelse(data$income == '$1 to $500,000', 1, 0)
# new_data$income_1500 <- ifelse(data$income == '$500,000 to $1,500,000', 1, 0)
# new_data$income_2500 <- ifelse(data$income == '$1,500,000 to $2,500,000', 1, 0)
# new_data$income_3500 <- ifelse(data$income == '$2,500,000 to $3,500,000', 1, 0)
# new_data$income_4500 <- ifelse(data$income == '$3,500,000 to $4,500,000', 1, 0)
# # No income_5500 because we don't have any observations in 4.5mil to 5.5mil
# # new_data$income_6500 <- ifelse(data$income == '$5,500,000 and greater', 1, 0)
# new_data$income <- NULL
# 
# 
# new_data$expense_20 <- ifelse(data$expense == '$0 to $20,000', 1, 0)
# new_data$expense_60 <- ifelse(data$expense == '$20,000 to $60,000', 1, 0)
# new_data$expense_100 <- ifelse(data$expense == '$60,000 to $100,000', 1, 0)
# new_data$expense_140 <- ifelse(data$expense == '$100,000 to $140,000', 1, 0)
# new_data$expense_180 <- ifelse(data$expense == '$140,000 to $180,000', 1, 0)
# new_data$expense_220 <- ifelse(data$expense == '$180,000 to $220,000', 1, 0)
# new_data$expense_260 <- ifelse(data$expense == '$220,000 to $260,000', 1, 0)
# new_data$expense_300 <- ifelse(data$expense == '$260,000 to $300,000', 1, 0)
# new_data$expense <- NULL
# 
# 
# new_data$net.income_20 <- ifelse(data$net.income == '$0 to $20,000', 1, 0)
# new_data$net.income_60 <- ifelse(data$net.income == '$20,000 to $60,000', 1, 0)
# new_data$net.income_100 <- ifelse(data$net.income == '$60,000 to $100,000', 1, 0)
# new_data$net.income_140 <- ifelse(data$net.income == '$100,000 to $140,000', 1, 0)
# new_data$net.income_180 <- ifelse(data$net.income == '$140,000 to $180,000', 1, 0)
# new_data$net.income_220 <- ifelse(data$net.income == '$180,000 to $220,000', 1, 0)
# new_data$net.income_260 <- ifelse(data$net.income == '$220,000 to $260,000', 1, 0)
# new_data$net.income_300 <- ifelse(data$net.income == '$260,000 to $300,000', 1, 0)
# new_data$net.income <- NULL
# 
# 
# # sex_m sex_f 
# # age_18_25 age_26_35 age_36_45 age_46_55 
# # status_fe status_pe status_ne status_cg status_fs status_ps 
# # pay_weekly pay_bi_weekly pay_semi_monthly pay_monthly
# # income_0 income_500 income_1500 income_2500 income_3500 income_4500
# # expense_20 expense_60 expense_100 expense_140 expense_180 expense_220 expense_260 expense_300
# # net.income_20 net.income_60 net.income_100 net.income_140 net.income_180 net.income_220 net.income_260 net.income_300
# 
# new_data <- new_data %>%
#   select( sex_m, sex_f, age_18_25, age_26_35, age_36_45, age_46_55, 
#           status_fe, status_pe, status_ne, status_cg, status_fs, status_ps, 
#           pay_weekly, pay_bi_weekly, pay_semi_monthly, pay_monthly, 
#           income_0, income_500, income_1500, income_2500, income_3500, income_4500, 
#           expense_20, expense_60, expense_100, expense_140, expense_180, expense_220, expense_260, expense_300, 
#           net.income_20, net.income_60, net.income_100, net.income_140, net.income_180, net.income_220, net.income_260, net.income_300, everything())
# 
# 
# ### -- Split data into training and testing
# set.seed(8) # 2, 5, 6
# train <- sample(1:nrow(new_data), nrow(new_data)*0.8)
# training.data <- new_data[train, ]
# testing.data <- new_data[-train, ]
# 
# 
# ### BUILD THE MODELS
# saving.model.1 <- lm(saving.preference ~ sex_m + sex_f + 
#               age_18_25 + age_26_35 + age_36_45 + age_46_55 + 
#               status_fe + status_pe + status_ne + status_cg + status_fs + status_ps + 
#               pay_weekly + pay_bi_weekly + pay_semi_monthly + pay_monthly + 
#               income_0 + income_500 + income_1500 + income_2500 + income_3500 + income_4500 + 
#               expense_20 + expense_60 + expense_100 + expense_140 + expense_180 + expense_220 + expense_260 + expense_300 +
#               net.income_20 + net.income_60 + net.income_100 + net.income_140 + net.income_180 + net.income_220 + net.income_260 + net.income_300 +
#               risk.appetite, data = new_data)
# 
# saving.model.1 <- lm(saving.preference ~ sex_m + sex_f + 
#                        age_18_25 + age_26_35 + age_36_45 + age_46_55 + 
#                        status_fe + status_pe + status_ne + status_cg + status_fs + status_ps + 
#                        pay_weekly + pay_bi_weekly + pay_semi_monthly + pay_monthly + 
#                        income_0 + income_500 + income_1500 + income_2500 + income_3500 + income_4500 + 
#                        expense_20 + expense_60 + expense_100 + expense_140 + expense_180 + expense_220 + expense_260 + expense_300 +
#                        net.income_20 + net.income_60 + net.income_100 + net.income_140 + net.income_180 + net.income_220 + net.income_260 + net.income_300 +
#                        risk.appetite + 
#                        saving.minimum.deposit + saving.additional.fees + saving.time.period + saving.interest.rate + saving.risk, data = new_data)
# summary(saving.model.1)
# 
# 
# loan.model.1 <- lm(loan.preference ~ sex_m + sex_f + 
#                        age_18_25 + age_26_35 + age_36_45 + age_46_55 + 
#                        status_fe + status_pe + status_ne + status_cg + status_fs + status_ps + 
#                        pay_weekly + pay_bi_weekly + pay_semi_monthly + pay_monthly + 
#                        income_0 + income_500 + income_1500 + income_2500 + income_3500 + income_4500 + 
#                        expense_20 + expense_60 + expense_100 + expense_140 + expense_180 + expense_220 + expense_260 + expense_300 +
#                        net.income_20 + net.income_60 + net.income_100 + net.income_140 + net.income_180 + net.income_220 + net.income_260 + net.income_300 +
#                        risk.appetite, data = new_data)
# summary(loan.model.1)
# 
# 
# investment.model.1 <- lm(investment.preference ~ sex_m + sex_f + 
#                        age_18_25 + age_26_35 + age_36_45 + age_46_55 + 
#                        status_fe + status_pe + status_ne + status_cg + status_fs + status_ps + 
#                        pay_weekly + pay_bi_weekly + pay_semi_monthly + pay_monthly + 
#                        income_0 + income_500 + income_1500 + income_2500 + income_3500 + income_4500 + 
#                        expense_20 + expense_60 + expense_100 + expense_140 + expense_180 + expense_220 + expense_260 + expense_300 +
#                        net.income_20 + net.income_60 + net.income_100 + net.income_140 + net.income_180 + net.income_220 + net.income_260 + net.income_300 +
#                        risk.appetite, data = new_data)
# summary(investment.model.1)
# 
# 
# ### USING THE MODELS FOR PREDICTIONS
# predict(saving.model.1, testing.data[, 1:39])
# testing.data$predicted.saving <- as.integer(predict(saving.model.1, testing.data[,1:39]))
# 
# predict(loan.model.1, testing.data[, 1:39])
# testing.data$predicted.loan <- as.integer(predict(loan.model.1, testing.data[,1:39]))
# 
# predict(investment.model.1, testing.data[, 1:39])
# testing.data$predicted.investment <- as.integer(predict(investment.model.1, testing.data[,1:39]))
# 
# 
# ### Accuracy
# sum(ifelse(abs(testing.data$saving.preference - testing.data$predicted.saving) < 0.3, 1, 0))/nrow(testing.data) * 100
# 
# sum(ifelse(abs(testing.data$loan.preference - testing.data$predicted.loan) < 0.3, 1, 0))/nrow(testing.data) * 100
# 
# sum(ifelse(abs(testing.data$investment.preference - testing.data$predicted.investment) < 0.3, 1, 0))/nrow(testing.data) * 100



# View(data[!grepl('Full-time', data$status, TRUE) & !grepl('Part-time', data$status, TRUE), ])

# Important variables for MLR
# sex, age, status, pay.cycle, income, expenses, net.expense, risk.appetite
# we are predicting saving, loan and investment preference