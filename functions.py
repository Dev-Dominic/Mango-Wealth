import math
import operator

'''
Accepts a list of products and normalizes them using the Euclidean norm method.

products - list of list of products where the location of a 1 or 0 indicates if that attribute is present.
'''
def normalizeProducts(products):
    normalized_products = []

    for product in products:
        total_attributes = sum(map(lambda x: x * x, product))  # Sum of the squares

        normalized_products.append([attribute / math.sqrt(total_attributes) for attribute in product])

    return normalized_products


'''
LOGARITHMIC VERSION

Accepts a list of products and normalizes them using the Euclidean norm method.

products - list of list of products where the location of a 1 or 0 indicates if that attribute is present.
'''
def normalizeProducts_LOG(products):
    normalized_products = []

    for product in products:

        index = 0
        adjusted_product = []

        for attribute in product:
            if index == 0 or index == 6:
                pass
            else:
                if attribute == 0:
                    adjusted_product.append(0)
                else:
                    adjusted_product.append(1 + math.log10(attribute))

            index = index + 1

        total_attributes = sum(map(lambda x: x * x, adjusted_product))  # Sum of the squares

        normalized_products.append([attribute / math.sqrt(total_attributes) for attribute in adjusted_product])

    return normalized_products


'''
Accepts two vectors and returns the sum of their products.
'''
def sumproduct(vec1, vec2):
    return sum(map(operator.mul, vec1, vec2))


'''
BASED ON TYPE OF PRODUCT i.e. Saving, Loan, Investment

Accepts a list of user preferences and calculates its productsum with a list of normalized products. Ranks
the results to determine the most suitable products for the user.

user - list of user preferences where the location of a: 
       1 indicates the user prioritizes that attribute of a product,
       0 indicates the user is neutral towards that attribute of a product,
       -1 indicates the user does not want that attribute of a product

normalized_products - list of list of products' Euclidean norm for each attribute
'''
def matchUser_product(user, normalized_products):
    attribute_columns = []  # Holds the normalized values for an attribute for each product

    for attribute_index in range(len(normalized_products[0])):
        attribute_columns.append([normalized_product[attribute_index] for normalized_product in normalized_products])

    # Holds the sumproduct of user preferences and attribute column. Should tell us which attributes are most important to the user.
    user_profile = [sumproduct(user, attribute_column) for attribute_column in attribute_columns]

    # Holds the predicted sumproduct values for products to determine what a user would like
    predicted_user_profile = []

    for row in normalized_products:
        predicted_user_profile.append(sumproduct(user_profile, row))

    return predicted_user_profile


# user vector - [gender, age, employment_status, risk_profile, income, expenses, net income]
def getUserVector(user_vector):
    user_dict = dict()

    user_dict['sex.female'] = 1 if user_vector[0] == 'FEMALE' else 0
    user_dict['sex.male'] = 1 if user_vector[0] == 'MALE' else 0

    user_dict['age.18 - 25'] = 1 if 18 <= user_vector[1] <= 25 else 0
    user_dict['age.26 - 35'] = 1 if 26 <= user_vector[1] <= 35 else 0
    user_dict['age.36 - 25'] = 1 if 36 <= user_vector[1] <= 45 else 0
    user_dict['age.46 - 25'] = 1 if 46 <= user_vector[1] <= 55 else 0
    user_dict['age.56 - 25'] = 1 if 56 <= user_vector[1] <= 65 else 0
    user_dict['age.gt 65'] = 1 if user_vector[1] > 65 else 0

    user_dict['status.FTE'] = 1 if user_vector[2] == 'FULL-TIME' else 0
    user_dict['status.PTE'] = 1 if user_vector[2] == 'PART-TIME' else 0
    user_dict['status.FTS'] = 1 if user_vector[2] == 'FULL-TIME STUDENT' else 0
    user_dict['status.PTS'] = 1 if user_vector[2] == 'PART-TIME STUDENT' else 0
    user_dict['status.U'] = 1 if user_vector[2] == 'UNEMPLOYED' else 0
    user_dict['status.FTE-FTS'] = 1 if user_vector[2] == 'FULL-TIME; FULL-TIME STUDENT' else 0
    user_dict['status.FTE-PTS'] = 1 if user_vector[2] == 'FULL-TIME; PART-TIME STUDENT' else 0
    user_dict['status.PTE-FTS'] = 1 if user_vector[2] == 'PART-TIME; FULL-TIME STUDENT' else 0
    user_dict['status.PTE-PTS'] = 1 if user_vector[2] == 'PART-TIME; PART-TIME STUDENT' else 0
    user_dict['status.U-FTS'] = 1 if user_vector[2] == 'UNEMPLOYED; FULL-TIME STUDENT' else 0

    user_dict['risk'] = user_vector[3]

    user_dict['income.$0'] = 1 if user_vector[4] <= 0 else 0
    user_dict['income.$1 - $500,000'] = 1 if 1 <= user_vector[4] <= 500000 else 0
    user_dict['income.$500,000 - $1,500,000'] = 1 if 500000 < user_vector[4] <= 1500000 else 0
    user_dict['income.$1,500,000 - $2,500,000'] = 1 if 1500000 < user_vector[4] <= 2500000 else 0
    user_dict['income.$2,500,000 - $3,500,000'] = 1 if 2500000 < user_vector[4] <= 3500000 else 0
    user_dict['income.$3,500,000 - $4,500,000'] = 1 if 3500000 < user_vector[4] <= 4500000 else 0
    user_dict['income.$4,500,000 - $5,500,000'] = 1 if 4500000 < user_vector[4] <= 5500000 else 0
    user_dict['income.gt $5,500,000'] = 1 if 5500000 < user_vector[4] <= 500000 else 0

    user_dict['expense.$0 - $20,000'] = 1 if 0 <= user_vector[5] <= 20000 else 0
    user_dict['expense.$20,000 - $60,000'] = 1 if 20000 < user_vector[5] <= 60000 else 0
    user_dict['expense.$60,000 - $100,000'] = 1 if 60000 < user_vector[5] <= 100000 else 0
    user_dict['expense.$100,000 - $140,000'] = 1 if 100000 < user_vector[5] <= 140000 else 0
    user_dict['expense.$140,000 - $180,000'] = 1 if 140000 < user_vector[5] <= 180000 else 0
    user_dict['expense.$180,000 - $220,000'] = 1 if 180000 < user_vector[5] <= 220000 else 0
    user_dict['expense.$220,000 - $260,000'] = 1 if 220000 < user_vector[5] <= 260000 else 0
    user_dict['expense.$260,000 - $300,000'] = 1 if 260000 < user_vector[5] <= 300000 else 0
    user_dict['expense.gt $300,000'] = 1 if 300000 < user_vector[5] else 0

    user_dict['net.income.$0 - $20,000'] = 1 if 0 <= user_vector[6] <= 20000 else 0
    user_dict['net.income.$20,000 - $60,000'] = 1 if 20000 < user_vector[6] <= 60000 else 0
    user_dict['net.income.$60,000 - $100,000'] = 1 if 60000 < user_vector[6] <= 100000 else 0
    user_dict['net.income.$100,000 - $140,000'] = 1 if 100000 < user_vector[6] <= 140000 else 0
    user_dict['net.income.$140,000 - $180,000'] = 1 if 140000 < user_vector[6] <= 180000 else 0
    user_dict['net.income.$180,000 - $220,000'] = 1 if 180000 < user_vector[6] <= 220000 else 0
    user_dict['net.income.$220,000 - $260,000'] = 1 if 220000 < user_vector[6] <= 260000 else 0
    user_dict['net.income.$260,000 - $300,000'] = 1 if 260000 < user_vector[6] <= 300000 else 0
    user_dict['net.income.gt $300,000'] = 1 if 300000 < user_vector[6] else 0

    return user_dict

# product vector - [product_id, minimum_deposit, additional_fees, maturity_period, interest_rate, risk_profile, category]
def getProductVector(product_vector):
    product_dict = dict()

    product_dict['id'] = product_vector[0]
    product_dict['minimum.deposit'] = product_vector[1]
    product_dict['additional.fees'] = product_vector[2]
    product_dict['maturity.period'] = product_vector[3]
    product_dict['interest.rate'] = product_vector[4]
    product_dict['risk'] = product_vector[5]
    product_dict['category'] = product_vector[6]

    return product_dict


def predictSavingPreference(user_dict):
    predicted_saving_preference = 3.94937437 * (user_dict['sex.female']) + \
                                  4.05890239 * (user_dict['sex.male']) + \
                                  1.47404077 * (user_dict['status.FTE-FTS']) - \
                                  0.03535749 * (user_dict['status.FTE-PTS']) - \
                                  1.79016253 * (user_dict['status.FTS']) + \
                                  0.39796802 * (user_dict['status.U']) - \
                                  0.21592187 * (user_dict['status.U-FTS']) + \
                                  1.73208377 * (user_dict['status.PTE']) + \
                                  0.73173831 * (user_dict['status.PTE-FTS']) + \
                                  0.20349169 * (user_dict['status.PTE-PTS']) - \
                                  1.15286606 * (user_dict['net.income.$20,000 - $60,000']) - \
                                  0.70742210 * (user_dict['net.income.$60,000 - $100,000']) - \
                                  2.06722635 * (user_dict['net.income.$100,000 - $140,000']) - \
                                  0.97127998 * (user_dict['net.income.$140,000 - $180,000']) - \
                                  0.33966770 * (user_dict['net.income.$180,000 - $220,000']) - \
                                  1.37127998 * (user_dict['net.income.$220,000 - $260,000']) - \
                                  0.69468479 * (user_dict['net.income.$260,000 - $300,000'])

    return predicted_saving_preference


def predictLoanPreference(user_dict):
    predicted_loan_preference = 3.6369263 * (user_dict['sex.female']) + \
                                3.9555266 * (user_dict['sex.male']) + \
                                0.9033174 * (user_dict['status.FTE-FTS']) - \
                                2.2588235 * (user_dict['status.FTE-PTS']) + \
                                0.2530111 * (user_dict['status.FTS']) + \
                                1.1641507 * (user_dict['status.U']) - \
                                0.2441071 * (user_dict['status.U-FTS']) - \
                                0.7559314 * (user_dict['status.PTE']) - \
                                1.4730329 * (user_dict['status.PTE-FTS']) - \
                                2.1990529 * (user_dict['status.PTE-PTS']) + \
                                0.8624444 * (user_dict['income.$1 - $500,000']) - \
                                0.2165519 * (user_dict['income.$500,000 - $1,500,000']) - \
                                0.6500143 * (user_dict['income.$1,500,000 - $2,500,000']) - \
                                0.9474887 * (user_dict['income.$2,500,000 - $3,500,000']) - \
                                0.5714845 * (user_dict['income.$4,500,000 - $5,500,000']) - \
                                2.7024854 * (user_dict['income.gt $5,500,000']) + \
                                0.3987808 * (user_dict['net.income.$20,000 - $60,000']) + \
                                1.8373824 * (user_dict['net.income.$60,000 - $100,000']) + \
                                1.5322493 * (user_dict['net.income.$100,000 - $140,000']) + \
                                1.6848111 * (user_dict['net.income.$140,000 - $180,000']) + \
                                2.0826226 * (user_dict['net.income.$180,000 - $220,000']) + \
                                0.6156837 * (user_dict['net.income.$220,000 - $260,000']) + \
                                1.1451559 * (user_dict['net.income.gt $300,000']) - \
                                0.3495493 * (user_dict['risk'])

    return predicted_loan_preference


def predictInvestmentPreference(user_dict):
    predicted_investment_preference = 2.15332833 * (user_dict['sex.female']) + \
                                      2.48643833 * (user_dict['sex.male']) + \
                                      0.03636973 * (user_dict['income.$1 - $500,000']) + \
                                      0.14631828 * (user_dict['income.$500,000 - $1,500,000']) + \
                                      0.21800050 * (user_dict['income.$1,500,000 - $2,500,000']) - \
                                      1.14031119 * (user_dict['income.$2,500,000 - $3,500,000']) + \
                                      0.13412110 * (user_dict['income.$4,500,000 - $5,500,000']) + \
                                      0.34188100 * (user_dict['income.gt $5,500,000']) + \
                                      0.54292017 * (user_dict['risk'])

    return predicted_investment_preference



# Print statements just for debugging
if __name__ == "__main__":
    # products = [[1, 0, 0, 1, 1],
    #             [1, 0, 0, 1, 1],
    #             [0, 1, 1, 1, 1],
    #             [0, 1, 1, 1, 1],
    #             [1, 0, 1, 1, 1],
    #             [1, 1, 1, 1, 1]]
    #
    # # users ['MALE', 21, 'FTE-FTS', 4, 300, 200, 100]
    #
    # user1 = [1, 1, -1, -1]
    # user2 = [0, 0, 1, 1, -1, -1]
    # user3 = [0, 0, 1, 1, 1, 1]
    #
    # normalized_products = normalizeProducts(products)
    #
    # print('Normalized Product Vectors -- Normalizing means that the vector lengths are equal to 1')
    #
    # for normalized_product in normalized_products:
    #     print(normalized_product)
    #
    # print()
    #
    # print('Matching user to a product based on their indicated or inferred product-type preference')
    #
    # print('USER 1')
    # matchUser_product(user1, normalized_products)
    #
    # print('USER 2')
    # # matchUser_product(user2, normalized_products)
    #
    # print('USER 3')
    # # matchUser_product(user3, normalized_products)




# --------------------------------------------

    product_list = ...  # Get this from API. LIST OF LISTS
    user = ...  # Get this from API. One user LIST

    user_vec = getUserVector(user) # user_vec == user_dict

    user_preferences = []
    user_preferences.append(predictSavingPreference(user_vec))
    user_preferences.append(predictLoanPreference(user_vec))
    user_preferences.append(predictInvestmentPreference(user_vec))

    normalized_products = normalizeProducts_LOG(product_list) # normalized_products DOES NOT have id and category

    saving_minimum_deposit_sum = 0
    saving_additional_fees_sum = 0
    saving_maturity_period_sum = 0
    saving_interest_rate_sum = 0
    saving_risk_score_sum = 0

    loan_minimum_deposit_sum = 0
    loan_additional_fees_sum = 0
    loan_maturity_period_sum = 0
    loan_interest_rate_sum = 0
    loan_risk_score_sum = 0

    investment_minimum_deposit_sum = 0
    investment_additional_fees_sum = 0
    investment_maturity_period_sum = 0
    investment_interest_rate_sum = 0
    investment_risk_score_sum = 0

    for index, product in enumerate(normalized_products):
        if product_list[index][-1] == 'S':
            saving_minimum_deposit_sum = saving_minimum_deposit_sum + product[0] * user_preferences[0]
            saving_additional_fees_sum = saving_additional_fees_sum + product[1] * user_preferences[0]
            saving_maturity_period_sum = saving_maturity_period_sum + product[2] * user_preferences[0]
            saving_interest_rate_sum = saving_interest_rate_sum + product[3] * user_preferences[0]
            saving_risk_score_sum = saving_risk_score_sum + product[4] * user_preferences[0]
        elif product_list[index][-1] == 'L':
            loan_minimum_deposit_sum = loan_minimum_deposit_sum + product[0] * user_preferences[1]
            loan_additional_fees_sum = loan_additional_fees_sum + product[1] * user_preferences[1]
            loan_maturity_period_sum = loan_maturity_period_sum + product[2] * user_preferences[1]
            loan_interest_rate_sum = loan_interest_rate_sum + product[3] * user_preferences[1]
            loan_risk_score_sum = loan_risk_score_sum + product[4] * user_preferences[1]
        elif product_list[index][-1] == 'I':
            investment_minimum_deposit_sum = investment_minimum_deposit_sum + product[0] * user_preferences[2]
            investment_additional_fees_sum = investment_additional_fees_sum + product[1] * user_preferences[2]
            investment_maturity_period_sum = investment_maturity_period_sum + product[2] * user_preferences[2]
            investment_interest_rate_sum = investment_interest_rate_sum + product[3] * user_preferences[2]
            investment_risk_score_sum = investment_risk_score_sum + product[4] * user_preferences[2]

    recommendation_scores = []  # For each product

    for index, product in enumerate(normalized_products):
        if product_list[index][-1] == 'S':
            saving_minimum_deposit_score = saving_minimum_deposit_sum * product[0]
            saving_additional_fees_score = saving_additional_fees_sum * product[1]
            saving_maturity_period_score = saving_maturity_period_sum * product[2]
            saving_interest_rate_score = saving_interest_rate_sum * product[3]
            saving_risk_score_score = saving_risk_score_sum * product[4]

            recommendation_scores.append(saving_minimum_deposit_score + saving_additional_fees_score + saving_maturity_period_score + saving_interest_rate_score + saving_risk_score_score)

        elif product_list[index][-1] == 'L':
            loan_minimum_deposit_score = loan_minimum_deposit_sum * product[0]
            loan_additional_fees_score = loan_additional_fees_sum * product[1]
            loan_maturity_period_score = loan_maturity_period_sum * product[2]
            loan_interest_rate_score = loan_interest_rate_sum * product[3]
            loan_risk_score_score = loan_risk_score_sum * product[4]

            recommendation_scores.append(
                loan_minimum_deposit_score + loan_additional_fees_score + loan_maturity_period_score + loan_interest_rate_score + loan_risk_score_score)

        elif product_list[index][-1] == 'I':
            investment_minimum_deposit_score = investment_minimum_deposit_sum * product[0]
            investment_additional_fees_score = investment_additional_fees_sum * product[1]
            investment_maturity_period_score = investment_maturity_period_sum * product[2]
            investment_interest_rate_score = investment_interest_rate_sum * product[3]
            investment_risk_score_score = investment_risk_score_sum * product[4]

            recommendation_scores.append(
                investment_minimum_deposit_score + investment_additional_fees_score + investment_maturity_period_score + investment_interest_rate_score + investment_risk_score_score)

    for index, score in enumerate(recommendation_scores):
        print(index + 1, score)

