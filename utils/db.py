import os

import mysql.connector
from dotenv import load_dotenv

load_dotenv()

def db_connection():
    mydb = mysql.connector.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        database=os.getenv("DB_NAME")
    )
    mydb.autocommit = False
    cursor = mydb.cursor()

    return mydb, cursor

def insert_update(db_instance, queryString, commit=False, want_result=False):
    # Getting database connection instance and cusror to execute queries
    mydb, cursor = db_instance
    try:

        print(f"Executing query: {queryString}")
        cursor.execute(queryString);

        print(cursor.rowcount, "record inserted/updated.")
        result = None
        if want_result:
            result = cursor.fetchall()

        # Possibly the case that their are subsequent sql queries to be ran
        # thus changes may not be commited until all conditions and
        # insertions/updates are made.
        if commit is True:
            mydb.commit()

        return True, result
    except:
        print('An error occured when trying to execute query')
        mydb.rollback()
        mydb.close()
        return False, None

def select(queryString):
    try:
        # Getting database connection instance and cusror to execute queries
        _, cursor = db_connection()

        print(f'Executing query: {queryString}')
        cursor.execute(queryString);

        result = cursor.fetchall()
        return result
    except:
        print('An error occured when trying to execute query')
        return None

def call_proc(stored_procedure, args=None):
    try:
        # Getting database connection instance and cusror to execute queries
        _, cursor = db_connection()

        print(f'Executing query: {stored_procedure}')
        result = []
        if args is None:
            cursor.callproc(stored_procedure);
        else:
            cursor.callproc(stored_procedure, args);

        for i in cursor.stored_results():
            result = result + i.fetchall()

        return result
    except Exception as e:
        print(e)
        print('An error occured when trying to execute query')
        return None

