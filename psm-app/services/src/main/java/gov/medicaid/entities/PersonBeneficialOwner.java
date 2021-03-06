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
package gov.medicaid.entities;

import java.util.Date;
import javax.persistence.*;
/**
 * A person beneficial owner.
 *
 * @author TCSASSEMBLER
 * @version 1.0
 */
@javax.persistence.Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(discriminatorType = DiscriminatorType.STRING)
@DiscriminatorValue("Y")
public class PersonBeneficialOwner extends BeneficialOwner {

    /**
     * First name.
     */
    @Column(name = "first_name")
    private String firstName;

    /**
     * Middle name.
     */
    @Column(name = "middle_name")
    private String middleName;

    /**
     * Last name.
     */
    @Column(name="last_name")
    private String lastName;

    /**
     * SSN.
     */
    @Column()
    private String ssn;

    /**
     * Date of birth.
     */
    @Column(name="birth_dt")
    private Date dob;

    /**
     * Hire date.
     */
    @Column(name = "hired_at")
    private Date hireDate;

    /**
     * Relationship type.
     */
    @ManyToOne
    @JoinColumn(name = "relationship_type_code")
    private RelationshipType relationship;


    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getMiddleName() {
        return middleName;
    }

    public void setMiddleName(String middleName) {
        this.middleName = middleName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getSsn() {
        return ssn;
    }

    public void setSsn(String ssn) {
        this.ssn = ssn;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public Date getHireDate() {
        return hireDate;
    }

    public void setHireDate(Date hireDate) {
        this.hireDate = hireDate;
    }

    public RelationshipType getRelationship() {
        return relationship;
    }

    public void setRelationship(RelationshipType relationship) {
        this.relationship = relationship;
    }
}
