/*
 * Copyright 2012-2013 TopCoder, Inc.
 *
 * This code was developed under U.S. government contract NNH10CD71C.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 *     http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package gov.medicaid.process.enrollment;

import ca.uhn.fhir.model.api.annotation.Child;
import ca.uhn.fhir.model.api.annotation.DatatypeDef;
import ca.uhn.fhir.model.api.annotation.ResourceDef;
import ca.uhn.fhir.rest.client.IGenericClient;
import ca.uhn.fhir.rest.client.ServerValidationModeEnum;
import ca.uhn.fhir.rest.server.EncodingEnum;
import com.topcoder.util.log.Level;
import com.topcoder.util.log.Log;
import gov.medicaid.binders.XMLUtility;
import gov.medicaid.domain.model.EnrollmentProcess;
import gov.medicaid.domain.model.ExternalSourcesScreeningResultType;
import gov.medicaid.domain.model.ProviderInformationType;
import gov.medicaid.domain.model.ScreeningResultType;
import gov.medicaid.domain.model.ScreeningResultsType;
import gov.medicaid.domain.model.VerificationStatusType;
import gov.medicaid.services.util.LogUtil;
import org.drools.runtime.process.WorkItem;
import org.drools.runtime.process.WorkItemManager;
//import org.springframework.web.client.RestTemplate;
import ca.uhn.fhir.context.FhirContext;
import org.hl7.fhir.dstu3.model.BaseResource;
import org.hl7.fhir.dstu3.model.Bundle;
import org.hl7.fhir.dstu3.model.DateType;
import org.hl7.fhir.dstu3.model.IdType;
import org.hl7.fhir.dstu3.model.IntegerType;
import org.hl7.fhir.dstu3.model.Property;
import org.hl7.fhir.dstu3.model.Resource;
import org.hl7.fhir.dstu3.model.ResourceType;
import org.hl7.fhir.dstu3.model.StringType;
import org.hl7.fhir.instance.model.api.IAnyResource;
import org.hl7.fhir.instance.model.api.IBase;
import org.hl7.fhir.instance.model.api.IBaseMetaType;
import org.hl7.fhir.instance.model.api.IIdType;
import org.hl7.fhir.instance.model.api.IPrimitiveType;

import java.net.URI;
import java.util.Date;
import java.util.List;

/**
 * This checks the excluded providers from the OIG website.
 */
public class ExcludedProvidersScreeningHandler extends GenericHandler {
    private Log log = LogUtil.getLog("ExcludedProvidersScreeningHandler");

    private String baseUri;

    public ExcludedProvidersScreeningHandler(String baseUri) {
        this.baseUri = baseUri;
    }

    public void executeWorkItem(WorkItem item, WorkItemManager manager) {
        log.log(Level.INFO, "Checking provider exclusion.");
        EnrollmentProcess processModel = (EnrollmentProcess) item.getParameter("model");

        ProviderInformationType provider = XMLUtility.nsGetProvider(processModel);
        log.log(Level.INFO, "Provider NPI: ", provider.getNPI());

        VerificationStatusType verificationStatus =
                XMLUtility.nsGetVerificationStatus(processModel);
        log.log(
                Level.INFO,
                "TODO: set non-exclusion verification status: ",
                verificationStatus.getNonExclusion()
        );

        boolean providerIsExcluded = providerInLEIE(provider.getNPI());
        if (providerIsExcluded) {
            verificationStatus.setNonExclusion("Y");
        } else {
            verificationStatus.setNonExclusion("N");
        }

        ExternalSourcesScreeningResultType results = new ExternalSourcesScreeningResultType();
        results.setStatus(XMLUtility.newStatus("ERROR"));

        ScreeningResultsType screeningResults = XMLUtility.nsGetScreeningResults(processModel);
        ScreeningResultType screeningResultType = new ScreeningResultType();
        screeningResults.getScreeningResult().add(screeningResultType);

        screeningResultType.setExclusionVerificationResult(results.getSearchResults());
        screeningResultType.setScreeningType("EXCLUDED PROVIDERS");
        screeningResultType.setStatus(XMLUtility.newStatus("SUCCESS"));

        item.getResults().put("model", processModel);
        manager.completeWorkItem(item.getId(), item.getResults());
    }

    private boolean providerInLEIE(String npi) {
//        return providerInLEIE(npi, new RestTemplate());
        FhirContext context = FhirContext.forDstu3();
        context.registerCustomType(Exclusion.class);
        context.getRestfulClientFactory().setServerValidationMode(
                ServerValidationModeEnum.NEVER
        );
        IGenericClient client = context.newRestfulGenericClient(baseUri);
//        client.setEncoding(EncodingEnum.XML);
        Bundle results = client
                .search()
                .forResource("Exclusion")
                .where(new ca.uhn.fhir.rest.gclient.StringClientParam("npi").matches().value(npi))
                .returnBundle(org.hl7.fhir.dstu3.model.Bundle.class)
                .execute();
        return false;
    }

//    private boolean providerInLEIE(String npi, RestTemplate restTemplate) {
//        SearchResults result = restTemplate.getForObject(
//                baseUri + "/exclusion?npi={npi}",
//                SearchResults.class,
//                npi
//        );
//        return false;
//    }

    @ResourceDef(name = "Exclusion")
    public static class Exclusion extends Resource {
        @Child(name = "address")
        StringType address;
        @Child(name = "busname")
        StringType businessName;
        @Child(name = "city")
        StringType city;
        @Child(name = "dob")
        DateType dateOfBirth;
        @Child(name = "excldate")
        DateType exclusionDate;
        @Child(name = "excltype")
        StringType exclusionType;
        @Child(name = "firstname")
        StringType firstName;
        @Child(name = "general")
        StringType general;
        @Child(name = "exclusionId")
        IntegerType exclusionId;
        @Child(name = "lastname")
        StringType lastName;
        @Child(name = "midname")
        StringType middleName;
        @Child(name = "npi")
        IntegerType npi;
        @Child(name = "reindate")
        DateType reinDate;
        @Child(name = "speciality")
        StringType speciality;
        @Child(name = "state")
        StringType state;
        @Child(name = "upin")
        StringType upin;
        @Child(name = "waiverdate")
        DateType waiverDate;
        @Child(name = "waiverstate")
        StringType waiverState;
        @Child(name = "zip")
        StringType zip;

        public StringType getAddress() {
            return address;
        }

        public void setAddress(StringType address) {
            this.address = address;
        }

        public StringType getBusinessName() {
            return businessName;
        }

        public void setBusinessName(StringType businessName) {
            this.businessName = businessName;
        }

        public StringType getCity() {
            return city;
        }

        public void setCity(StringType city) {
            this.city = city;
        }

        public DateType getDateOfBirth() {
            return dateOfBirth;
        }

        public void setDateOfBirth(DateType dateOfBirth) {
            this.dateOfBirth = dateOfBirth;
        }

        public DateType getExclusionDate() {
            return exclusionDate;
        }

        public void setExclusionDate(DateType exclusionDate) {
            this.exclusionDate = exclusionDate;
        }

        public StringType getExclusionType() {
            return exclusionType;
        }

        public void setExclusionType(StringType exclusionType) {
            this.exclusionType = exclusionType;
        }

        public StringType getFirstName() {
            return firstName;
        }

        public void setFirstName(StringType firstName) {
            this.firstName = firstName;
        }

        public StringType getGeneral() {
            return general;
        }

        public void setGeneral(StringType general) {
            this.general = general;
        }

        public IntegerType getExclusionId() {
            return exclusionId;
        }

        public void setExclusionId(IntegerType exclusionId) {
            this.exclusionId = exclusionId;
        }

        public StringType getLastName() {
            return lastName;
        }

        public void setLastName(StringType lastName) {
            this.lastName = lastName;
        }

        public StringType getMiddleName() {
            return middleName;
        }

        public void setMiddleName(StringType middleName) {
            this.middleName = middleName;
        }

        public IntegerType getNpi() {
            return npi;
        }

        public void setNpi(IntegerType npi) {
            this.npi = npi;
        }

        public DateType getReinDate() {
            return reinDate;
        }

        public void setReinDate(DateType reinDate) {
            this.reinDate = reinDate;
        }

        public StringType getSpeciality() {
            return speciality;
        }

        public void setSpeciality(StringType speciality) {
            this.speciality = speciality;
        }

        public StringType getState() {
            return state;
        }

        public void setState(StringType state) {
            this.state = state;
        }

        public StringType getUpin() {
            return upin;
        }

        public void setUpin(StringType upin) {
            this.upin = upin;
        }

        public DateType getWaiverDate() {
            return waiverDate;
        }

        public void setWaiverDate(DateType waiverDate) {
            this.waiverDate = waiverDate;
        }

        public StringType getWaiverState() {
            return waiverState;
        }

        public void setWaiverState(StringType waiverState) {
            this.waiverState = waiverState;
        }

        public StringType getZip() {
            return zip;
        }

        public void setZip(StringType zip) {
            this.zip = zip;
        }

        @Override
        public Resource copy() {
            return null;
        }

        @Override
        public ResourceType getResourceType() {
            return null;
        }
    }

    private class SearchResultEntry {
        public String fullUrl;
        public Exclusion resource;
    }

    private class Link {
        public String relation;
        public String url;
    }

    private class SearchResults {
        public List<SearchResultEntry> entries;
        public List<Link> links;
        public String resourceType;
        public int total;
        public String type;
    }
}
