#!/bin/bash
export $(grep -v '^#' .env | xargs)

envsubst < ./images/mongodb-seed/template/catalog.representations.template.json > ./images/mongodb-seed/init/catalog.representations.json
envsubst < ./images/mongodb-seed/template/catalog.infrastructureservices.template.json > ./images/mongodb-seed/init/catalog.infrastructureservices.json
envsubst < ./images/mongodb-seed/template/catalog.ecosystems.template.json > ./images/mongodb-seed/init/catalog.ecosystems.json
envsubst < ./images/mongodb-seed/template/catalog.serviceofferings.template.json > ./images/mongodb-seed/init/catalog.serviceofferings.json
envsubst < ./images/mongodb-seed/template/catalog.softwareresources.template.json > ./images/mongodb-seed/init/catalog.softwareresources.json
envsubst < ./images/mongodb-seed/template/consent.participants.template.json > ./images/mongodb-seed/init/consent.participants.json
envsubst < ./images/mongodb-seed/template/contract.contracts.template.json > ./images/mongodb-seed/init/contract.contracts.json

sed -i 's/[\x00-\x1F]//g' ./images/mongodb-seed/init/catalog.representations.json
sed -i 's/[\x00-\x1F]//g' ./images/mongodb-seed/init/catalog.infrastructureservices.json
sed -i 's/[\x00-\x1F]//g' ./images/mongodb-seed/init/catalog.ecosystems.json
sed -i 's/[\x00-\x1F]//g' ./images/mongodb-seed/init/catalog.serviceofferings.json
sed -i 's/[\x00-\x1F]//g' ./images/mongodb-seed/init/catalog.softwareresources.json
sed -i 's/[\x00-\x1F]//g' ./images/mongodb-seed/init/consent.participants.json
sed -i 's/[\x00-\x1F]//g' ./images/mongodb-seed/init/contract.contracts.json

# Find and replace "_id": {"" with "_id": {"$oid" in each file
for file in ./images/mongodb-seed/init/*.json; do
    sed -i 's/"_id": {""/"_id": {"$oid"/g' $file
    sed -i 's/"": /"$oid": /g' $file
done

mongoimport --host mongodb --db $CATALOG_MONGO_DATABASE --collection softwareresources --type json --file ./images/mongodb-seed/init/catalog.softwareresources.json --jsonArray && \
mongoimport --host mongodb --db $CATALOG_MONGO_DATABASE --collection organizationadmins --type json --file ./images/mongodb-seed/init/catalog.organizationadmins.json --jsonArray && \
mongoimport --host mongodb --db $CATALOG_MONGO_DATABASE --collection globaldatatypes --type json --file ./images/mongodb-seed/init/catalog.globaldatatypes.json --jsonArray && \
mongoimport --host mongodb --db $CATALOG_MONGO_DATABASE --collection globalpurposes --type json --file ./images/mongodb-seed/init/catalog.globalpurposes.json --jsonArray && \
mongoimport --host mongodb --db $CATALOG_MONGO_DATABASE --collection participants --type json --file ./images/mongodb-seed/init/catalog.participants.json --jsonArray && \
mongoimport --host mongodb --db $CATALOG_MONGO_DATABASE --collection dataresources --type json --file ./images/mongodb-seed/init/catalog.dataresources.json --jsonArray && \
mongoimport --host mongodb --db $CATALOG_MONGO_DATABASE --collection ecosystems --type json --file ./images/mongodb-seed/init/catalog.ecosystems.json --jsonArray && \
mongoimport --host mongodb --db $CATALOG_MONGO_DATABASE --collection representations --type json --file ./images/mongodb-seed/init/catalog.representations.json --jsonArray && \
mongoimport --host mongodb --db $CATALOG_MONGO_DATABASE --collection serviceofferings --type json --file ./images/mongodb-seed/init/catalog.serviceofferings.json --jsonArray && \
mongoimport --host mongodb --db $CATALOG_MONGO_DATABASE --collection infrastructureservices --type json --file ./images/mongodb-seed/init/catalog.infrastructureservices.json --jsonArray && \
mongoimport --host mongodb --db $CONTRACT_MONGO_DATABASE --collection contracts --type json --file ./images/mongodb-seed/init/contract.contracts.json --jsonArray && \
mongoimport --host mongodb --db $CONSENT_MONGO_DATABASE --collection participants --type json --file ./images/mongodb-seed/init/consent.participants.json --jsonArray && \
mongoimport --host mongodb --db $CONSENT_MONGO_DATABASE --collection users --type json --file ./images/mongodb-seed/init/consent.users.json --jsonArray && \
mongoimport --host mongodb --db $CONSENT_MONGO_DATABASE --collection useridentifiers --type json --file ./images/mongodb-seed/init/consent.useridentifiers.json --jsonArray && \
mongoimport --host mongodb --db $PROVIDER_PDC_DATABASE --collection users --type json --file ./images/mongodb-seed/init/provider.users.json --jsonArray && \
mongoimport --host mongodb --db $CONSUMER_PDC_DATABASE --collection users --type json --file ./images/mongodb-seed/init/consumer.users.json --jsonArray && \
mongoimport --host mongodb --db $PROVIDER_API_DATABASE --collection users --type json --file ./images/mongodb-seed/init/example-api.users.json --jsonArray && \
mongoimport --host mongodb --db $CONSUMER_API_DATABASE --collection users --type json --file ./images/mongodb-seed/init/example-api.users.json --jsonArray
