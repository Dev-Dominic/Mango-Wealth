from .utils.db import db_connection, insert_update, select
import hashlib

def get_product_types_service():
    def convert_product_to_dict(product_id, product_name):
        return {
            'product_id': product_id,
            'product_name': product_name
        }

    result = select("SELECT * FROM ProductTypes")
    product_types = []
    for entry in result:
        product_id, product_name = entry[0], entry[1]
        product_types.append(convert_product_to_dict(product_id, product_name))
    return product_types


def onboarding_service(onboarding_body):
    success = False

    # Extracting user onboarding attributes
    first_name = onboarding_body.get('first_name')
    last_name = onboarding_body.get('last_name')
    age = int(onboarding_body.get('age'))
    gender = onboarding_body.get('gender').upper()
    employment_status = onboarding_body.get('employment_status').upper()
    salary_period = onboarding_body.get('salary_period').upper()
    email = onboarding_body.get('email')
    income = onboarding_body.get('income')
    expenses = onboarding_body.get('expenses')
    risk_profile = onboarding_body.get('risk_profile')
    product_types = onboarding_body.get('product_types')

    # Should update with more secure hashing function and salting
    password = onboarding_body.get('password')
    password_hash = hashlib.sha256(password.encode('utf-8')).hexdigest()

    db = db_connection()

    # Inserting user information
    user_insertion_query = f"""
        INSERT INTO Users(first_name, last_name, age, gender, employment_status,
        salary_period, risk_profile, email, password_hash)
        VALUES('{first_name}', '{last_name}', {age}, '{gender}',
        '{employment_status}', '{salary_period}', {risk_profile},'{email}', '{password_hash}')
        RETURNING id;
    """
    user_insertion_success, result = insert_update(db, user_insertion_query, want_result=True)

    if user_insertion_success:
        # Getting user entry id
        user_id = result[0][0]

        # Inserting initial user financial records
        user_financial_insertion = f"""
            INSERT INTO UserFinancialsRecords(income, expenses, recordDate,
            userId)
            VALUES({income}, {expenses}, NOW(), {user_id})
        """
        user_financial_insertion_success, _ = insert_update(db,
                                                            user_financial_insertion)

        if user_financial_insertion_success:

            # Insering user product attribute preferences
            commit = False
            for index, product_type in enumerate(product_types):
                productTypeId = product_type['productTypeId']
                minimum_deposit = product_type['minimum_deposit']
                additional_fees = product_type['additional_fees']
                interest_rate = product_type['interest_rate']
                time_period = product_type['time_period']
                risk = product_type['risk']
                preference_number = product_type['preference_number']

                user_product_preference = f"""
                    INSERT INTO UserProductPreferences(userId, productTypeId,
                    minimum_deposit, additional_fees, interest_rate, time_period,
                    risk, preference_number)
                    VALUES({user_id}, {productTypeId}, {minimum_deposit},
                    {additional_fees}, {interest_rate}, {time_period}, {risk},
                    {preference_number})
                """

                # Commits changes once last product type has been reached
                if index+1 == len(product_types):
                    commit = True

                user_product_preference_success, _ = insert_update(db,
                                                               user_product_preference,
                                                               commit)
                success = user_product_preference_success

    return success


def login_service():
    pass

def metrics_service():
    pass

def tracking_service():
    pass
