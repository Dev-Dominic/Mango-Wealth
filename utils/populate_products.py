import csv
import random
import sys

database = sys.argv[1]
sql_file_name = sys.argv[2]

def write_to_sql_file(file_ptr, entry):
    print(f'Entry made: {entry}')
    file_ptr.write(entry + '\n')

# Opening sql file to write insertions
with open(f'{sql_file_name}.sql', 'w') as sql_file:

    # Opening csv dataset containing financial products
    with open('../datasets/products.csv', 'r') as dataset:
        csv_reader = csv.DictReader(dataset, delimiter=',')
        for row in csv_reader:
            product_name = row.get('Product Name')
            product_institution = row.get('Finacial Institution')
            product_type = row.get('Product Category').upper()
            product_link = row.get('Link')

            minimum_deposit = 0
            if not row.get('Minimum Deposit') in ['?', 'None', None]:
                minimum_deposit = float(row.get('Minimum Deposit'))

            risk_profile = row.get('Risk Profile Score')
            if risk_profile == 'Low':
                risk_profile = random.randint(1, 2)
            elif risk_profile == 'Medium':
                risk_profile = 3
            elif risk_profile == 'High':
                risk_profile = random.randint(4, 5)

            interest_rate = 0
            if not row.get('Interest Rates') in ['?', 'None', None]:
                interest_rate = float(row.get('Interest Rates'))

            maturity_period = 0
            if not row.get('Max Lifetime') in ['?', 'None', None]:
                maturity_period = int(row.get('Max Lifetime'))

            # Currently no specification for Additional Fee types in dataset
            additional_fees_other = 0
            if not row.get('Additional Fees') in ['?', 'None', None]:
                additional_fees_other = float(row.get('Additional Fees'))

            # Creating insertion state for product
            entry = f"INSERT INTO FinancialProducts(product_name, description, minimum_deposit, risk_profile, interest_rate, maturity_period,product_link, productTypeId, institutionId) VALUES('{product_name}', '', {minimum_deposit}, {risk_profile}, {interest_rate}, {maturity_period},'{product_link}', (SELECT id FROM ProductTypes WHERE name='{product_type}'), (SELECT id FROM FinancialInstitutions WHERE name='{product_institution}'));"
            write_to_sql_file(sql_file, entry)

            # Creating relationship between additional fees and product
            additional_fees_entry = f"INSERT INTO FinancialProductsFees(financialProductId, feesId, amount) VALUES((SELECT id FROM FinancialProducts WHERE product_name='{product_name}'), 1, {additional_fees_other});"
            write_to_sql_file(sql_file, additional_fees_entry)
