DROP SEQUENCE IF EXISTS
  hibernate_sequence
CASCADE;
DROP TABLE IF EXISTS
  accepted_agreements,
  addresses,
  affiliations,
  agreement_documents,
  assured_services,
  audit_details,
  audit_records,
  beneficial_owner,
  beneficial_owner_types,
  binary_contents,
  categories_of_service,
  cms_authentication,
  cms_user,
  contacts,
  counties,
  degrees,
  designated_contacts,
  documents,
  enrollment_statuses,
  enrollments,
  entities,
  entity_structure_types,
  help_items,
  issuing_boards,
  license_statuses,
  license_types,
  licenses,
  organizations,
  owner_assets,
  ownership_types,
  pay_to_provider_types,
  people,
  persistent_logins,
  profile_statuses,
  provider_profiles,
  provider_statements,
  provider_type_agreement_documents,
  provider_type_license_types,
  provider_types,
  qualified_professional_types,
  relationship_types,
  request_types,
  required_field_types,
  risk_levels,
  roles,
  screening_schedules,
  service_assurance_ext_types,
  service_assurance_types,
  service_categories,
  specialty_types,
  states
CASCADE;

CREATE SEQUENCE hibernate_sequence;

CREATE TABLE persistent_logins (
  series VARCHAR(64) PRIMARY KEY,
  username VARCHAR(64) NOT NULL,
  token VARCHAR(64) NOT NULL,
  last_used TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE roles (
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE
);
INSERT INTO roles (code, description) VALUES
  ('R1', 'Provider'),
  ('R2', 'Service Agent'),
  ('R3', 'Service Administrator'),
  ('R4', 'System Administrator');

CREATE TABLE service_assurance_types (
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE,
  patient_indicator TEXT
);

CREATE TABLE service_assurance_ext_types (
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE,
  service_assurance_code CHARACTER VARYING(2) REFERENCES service_assurance_types(code)
);

CREATE TABLE cms_user (
  user_id TEXT PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  first_name TEXT,
  middle_name TEXT,
  last_name TEXT,
  phone_number TEXT,
  email TEXT,
  status TEXT,
  role_code CHARACTER VARYING(2) REFERENCES roles(code)
);
INSERT INTO cms_user (
  user_id,
  username,
  first_name,
  last_name,
  email,
  status,
  role_code
) VALUES
  ('provider1', 'provider1', 'provider1', 'provider1', 'provider1@example.com', 'ACTIVE', 'R1'),
  ('ADMIN', 'admin', 'admin', 'admin', 'admin@example.com', 'ACTIVE', 'R3'),
  ('SYSTEM', 'system', 'system', 'system', 'system@example.com', 'ACTIVE', 'R4');

CREATE TABLE cms_authentication(
  username TEXT PRIMARY KEY,
  password TEXT NOT NULL
);
INSERT INTO cms_authentication (username, password) VALUES
  ('admin', '{SHA}0DPiKuNIrrVmD8IUCuw1hQxNqZc='), -- password: admin
  ('provider1', '{SHA}jYzFgLRW5zKnz2IUiWwMUFEp+c4='),
  ('system', '{SHA}MX8edh8vqo2ngaR2K53MLFytIJo='); -- password: system

CREATE TABLE audit_records(
  audit_record_id BIGINT PRIMARY KEY,
  action TEXT,
  date TIMESTAMP WITH TIME ZONE,
  system_id TEXT,
  username TEXT
);
CREATE TABLE audit_details(
  audit_detail_id BIGINT PRIMARY KEY,
  audit_record_id BIGINT NOT NULL REFERENCES audit_records(audit_record_id),
  table_name TEXT,
  column_name TEXT,
  old_value TEXT,
  new_value TEXT
);
CREATE TABLE help_items(
  help_item_id BIGINT PRIMARY KEY,
  title TEXT,
  description TEXT
);

CREATE TABLE qualified_professional_types(
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE
);
INSERT INTO qualified_professional_types (code, description) VALUES
  ('01', 'Registered Nurse'),
  ('02', 'Licensed Social Worker'),
  ('03', 'Mental Health Professional'),
  ('04', 'Qualified Developmental Disability Specialist');

CREATE TABLE provider_types(
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE,
  applicant_type TEXT NOT NULL DEFAULT 'INDIVIDUAL'
);
INSERT INTO provider_types(code, description, applicant_type) VALUES
  ('01', 'Audiologist', 'INDIVIDUAL'),
  ('02', 'Optometrist', 'INDIVIDUAL'),
  ('03', 'Certified Registered Nurse Anesthetist', 'INDIVIDUAL'),
  ('04', 'Personal Care Assistant', 'INDIVIDUAL'),
  ('05', 'Certified Professional Midwife', 'INDIVIDUAL'),
  ('06', 'Community Health Care Worker', 'INDIVIDUAL'),
  ('07', 'Clinical Nurse Specialist', 'INDIVIDUAL'),
  ('08', 'Chiropractor', 'INDIVIDUAL'),
  ('09', 'Podiatrist', 'INDIVIDUAL'),
  ('10', 'Licensed Marriage and Family Therapist', 'INDIVIDUAL'),
  ('11', 'Licensed Professional Clinical Counselor', 'INDIVIDUAL'),
  ('12', 'Nurse Practitioner', 'INDIVIDUAL'),
  ('13', 'Occupational Therapist', 'INDIVIDUAL'),
  ('14', 'Physician Assistant', 'INDIVIDUAL'),
  ('15', 'Private Duty Nurse', 'INDIVIDUAL'),
  ('16', 'Physical Therapist', 'INDIVIDUAL'),
  ('17', 'Speech Language Pathologist', 'INDIVIDUAL'),
  ('18', 'Acupuncturist', 'INDIVIDUAL'),
  ('19', 'Allied Dental Professional', 'INDIVIDUAL'),
  ('20', 'Certified Mental Health Rehab Prof - CPRP', 'INDIVIDUAL'),
  ('21', 'Dentist', 'INDIVIDUAL'),
  ('22', 'Hearing Aid Dispenser', 'INDIVIDUAL'),
  ('23', 'Licensed Dietician or Licensed Nutritionist', 'INDIVIDUAL'),
  ('24', 'Licensed Independent Clinical Social Worker', 'INDIVIDUAL'),
  ('25', 'Nurse Midwife', 'INDIVIDUAL'),
  ('26', 'Pharmacist', 'INDIVIDUAL'),
  ('27', 'Licensed Psychologist', 'INDIVIDUAL'),
  ('28', 'Physician', 'INDIVIDUAL');

CREATE TABLE profile_statuses(
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE
);
INSERT INTO profile_statuses (code, description) VALUES
  ('01', 'Active'),
  ('02', 'Suspended'),
  ('03', 'Expired');

CREATE TABLE required_field_types(
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE
);
INSERT INTO required_field_types (code, description) VALUES
  ('01', 'Required'),
  ('02', 'Optional');

CREATE TABLE entity_structure_types(
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE
);
INSERT INTO entity_structure_types (code, description) VALUES
  ('01', 'Sole Proprietorship'),
  ('02', 'Partnership'),
  ('03', 'Corporation'),
  ('04', 'Non-Profit'),
  ('05', 'Hospital Based'),
  ('06', 'State'),
  ('07', 'Public'),
  ('08', 'Professional Association'),
  ('99', 'Other');

CREATE TABLE issuing_boards(
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE
);
INSERT INTO issuing_boards (code, description) VALUES
  ('B1', 'AANA'),
  ('B2', 'NARM'),
  ('B3', 'ANCC'),
  ('B4', 'AOTA'),
  ('B5', 'ADA'),
  ('B6', 'ABMS'),
  ('B7', 'ABPS');

CREATE TABLE license_statuses(
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE
);
INSERT INTO license_statuses (code, description) VALUES
  ('01', 'Active'),
  ('02', 'Suspended'),
  ('03', 'Expired');

CREATE TABLE ownership_types(
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE
);

CREATE TABLE pay_to_provider_types(
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE
);
INSERT INTO pay_to_provider_types(code, description) VALUES
  ('01', 'Claim'),
  ('02', 'ERA'),
  ('03', 'Both');

CREATE TABLE categories_of_service (
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE
);
INSERT INTO categories_of_service (code, description) VALUES
  ('01', 'AC Transportation'),
  ('02', 'Home Delivered Meals'),
  ('03', 'Adult Day Services'),
  ('04', 'Homemaker Services'),
  ('05', 'Behavioral Program Services'),
  ('06', 'In-home Family Support'),
  ('07', 'Caregiver Training'),
  ('08', 'Independent Living Skills'),
  ('09', 'Case Management Waiver/Alternative Care'),
  ('10', 'Modification and Adaptations'),
  ('11', 'Chore'),
  ('12', 'Nutritional Services'),
  ('13', 'Cognitive Therapy'),
  ('14', 'PERS and AC Supplies'),
  ('15', 'Companion Services'),
  ('16', 'Respite Care'),
  ('17', 'Consumer Directed Community Support (CDCS)'),
  ('18', 'Specialized Supplies & Equipment (Waiver)'),
  ('19', 'Spenddown Collection'),
  ('20', 'Customized Living, 24 CL, Residential Care Services, Assisted Living Services'),
  ('21', 'Structured Day Program Services'),
  ('22', 'Supported Employment Services'),
  ('23', 'Family Counseling and Training'),
  ('24', 'Supported Living Services'),
  ('25', 'Foster Care Services'),
  ('26', 'Waiver Transportation');


CREATE TABLE service_categories (
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE
);
INSERT INTO service_categories (code, description) VALUES
  ('01', 'AC Transportation'),
  ('02', 'Home Delivered Meals'),
  ('03', 'Adult Day Services'),
  ('04', 'Homemaker Services'),
  ('05', 'Behavioral Program Services'),
  ('06', 'In-home Family Support'),
  ('07', 'Caregiver Training'),
  ('08', 'Independent Living Skills'),
  ('09', 'Case Management Waiver/Alternative Care'),
  ('10', 'Modification and Adaptations'),
  ('11', 'Chore'),
  ('12', 'Nutritional Services'),
  ('13', 'Cognitive Therapy'),
  ('14', 'PERS and AC Supplies'),
  ('15', 'Companion Services'),
  ('16', 'Respite Care'),
  ('17', 'Consumer Directed Community Support (CDCS)'),
  ('18', 'Specialized Supplies & Equipment (Waiver)'),
  ('19', 'Spenddown Collection'),
  ('20', 'Customized Living, 24 CL, Residential Care Services, Assisted Living Services'),
  ('21', 'Structured Day Program Services'),
  ('22', 'Supported Employment Services'),
  ('23', 'Family Counseling and Training'),
  ('24', 'Supported Living Services'),
  ('25', 'Foster Care Services'),
  ('26', 'Waiver Transportation');

CREATE TABLE counties (
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE
);
INSERT INTO counties (code, description) VALUES
  ('01', 'Aitkin'),
  ('02', 'Anoka'),
  ('03', 'Becker'),
  ('04', 'Beltrami'),
  ('05', 'Benton'),
  ('06', 'Big Stone'),
  ('07', 'Blue Earth'),
  ('08', 'Brown'),
  ('09', 'Carlton'),
  ('10', 'Carver'),
  ('11', 'Cass'),
  ('12', 'Chippewa'),
  ('13', 'Chisago'),
  ('14', 'Clay'),
  ('15', 'Clearwater'),
  ('16', 'Cook'),
  ('17', 'Cottonwood'),
  ('18', 'Crow Wing'),
  ('19', 'Dakota'),
  ('20', 'Dodge'),
  ('21', 'Douglas'),
  ('22', 'Faribault'),
  ('23', 'Fillmore'),
  ('24', 'Freeborn'),
  ('25', 'Goodhue'),
  ('26', 'Grant'),
  ('27', 'Hennepin'),
  ('28', 'Houston'),
  ('29', 'Hubbard'),
  ('30', 'Isanti'),
  ('31', 'Itasca'),
  ('32', 'Jackson'),
  ('33', 'Kanabec'),
  ('34', 'Kandiyohi'),
  ('35', 'Kittson'),
  ('36', 'Koochiching'),
  ('37', 'Lac qui Parle'),
  ('38', 'Lake'),
  ('39', 'Lake of the Woods'),
  ('40', 'Le Sueur'),
  ('41', 'Lincoln'),
  ('42', 'Lyon'),
  ('43', 'Mahnomen'),
  ('44', 'Marshall'),
  ('45', 'Martin'),
  ('46', 'McLeod'),
  ('47', 'Meeker'),
  ('48', 'Mille Lacs'),
  ('49', 'Morrison'),
  ('50', 'Mower'),
  ('51', 'Murray'),
  ('52', 'Nicollet'),
  ('53', 'Nobles'),
  ('54', 'Norman'),
  ('55', 'Olmsted'),
  ('56', 'Otter Tail'),
  ('57', 'Pennington'),
  ('58', 'Pine'),
  ('59', 'Pipestone'),
  ('60', 'Polk'),
  ('61', 'Pope'),
  ('62', 'Ramsey'),
  ('63', 'Red Lake'),
  ('64', 'Redwood'),
  ('65', 'Renville'),
  ('66', 'Rice'),
  ('67', 'Rock'),
  ('68', 'Roseau'),
  ('69', 'Scott'),
  ('70', 'Sherburne'),
  ('71', 'Sibley'),
  ('72', 'St. Louis'),
  ('73', 'Stearns'),
  ('74', 'Steele'),
  ('75', 'Stevens'),
  ('76', 'Swift'),
  ('77', 'Todd'),
  ('78', 'Traverse'),
  ('79', 'Wabasha'),
  ('80', 'Wadena'),
  ('81', 'Waseca'),
  ('82', 'Washington'),
  ('83', 'Watonwan'),
  ('84', 'Wilkin'),
  ('85', 'Winona'),
  ('86', 'Wright'),
  ('87', 'Yellow');

CREATE TABLE beneficial_owner_types(
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE,
  owner_type CHARACTER VARYING(1)
);
INSERT INTO beneficial_owner_types (code, owner_type, description) VALUES
  ('01', 'A', 'Subcontractor'),
  ('02', 'P', 'Managing Employee'),
  ('03', 'A', 'Owner - 5% or more of Ownership Interest'),
  ('04', 'P', 'Board Member or Officer'),
  ('05', 'P', 'Program Manager'),
  ('06', 'P', 'Managing Director'),
  ('99', 'A', 'Other');

CREATE TABLE risk_levels(
  code CHARACTER VARYING(2) PRIMARY KEY,
  sort_index INTEGER UNIQUE NOT NULL,
  description TEXT UNIQUE
);
INSERT INTO risk_levels (code, sort_index, description) VALUES
  ('01', 1, 'Limited'),
  ('02', 2, 'Moderate'),
  ('03', 3, 'High');

CREATE TABLE degrees(
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE
);
INSERT INTO degrees(CODE, DESCRIPTION) VALUES
  ('D1', 'MASTERS'),
  ('D2', 'DOCTORATE');

CREATE TABLE relationship_types(
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE
);
INSERT INTO relationship_types (CODE, DESCRIPTION) VALUES
  ('01', 'Spouse'),
  ('02', 'Child'),
  ('03', 'Parent'),
  ('04', 'Sibling');

CREATE TABLE enrollment_statuses(
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE
);
INSERT INTO enrollment_statuses (code, description) VALUES
  ('01', 'Draft'),
  ('02', 'Pending'),
  ('03', 'Rejected'),
  ('04', 'Approved');

CREATE TABLE license_types(
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE
);
INSERT INTO license_types (code, description) VALUES
  ('A0', 'Background Study'),
  ('A1', 'Head Start Agency Certification'),
  ('A2', 'Class A Professional Home Care License'),
  ('A3', 'HCFA Medicare Certification'),
  ('A4', 'Housing with Services'),
  ('A5', 'Off-site Approval Letter From Medicare'),
  ('A6', 'Verification of IHS status'),
  ('A7', 'County Contract to Provider IRTS'),
  ('A8', 'Rule 36 Licensed Facility'),
  ('A9', 'Class A License'),
  ('AA', 'Pharmacy License'),
  ('AB', 'Class A License For Private Duty Nursing Services'),
  ('AC', 'Medicare Certification For Home Health Aide And Skilled Nursing Services'),
  ('AD', 'Regional Treatment Center Certification'),
  ('AE', 'Medicare Approval Letter'),
  ('AF', 'Comprehensive Outpatient Rehabilitation Facility Certification'),
  ('AG', 'Independent or Portable X-ray Certification from CMS'),
  ('AH', 'FDA Certification - Mammography services'),
  ('AI', 'PCA 1 or 3 day Steps for Success Training'),
  ('AJ', 'Medicare Certification'),
  ('AK', 'Rule 5 License issued from MN Department of Human Services'),
  ('AL', 'Certificate of Compliance from MN Department of Human Rights'),
  ('AM', 'Rule 29 License'),
  ('AN', 'Day Training & Habilitation License'),
  ('AO', 'License and Transmittal (CMS 1539 Form) from MN Department of Health'),
  ('AP', 'Approval by Kent Dufresne to enroll new facility'),
  ('AQ', 'Hospice license from the MN Dept of Health'),
  ('AR', 'CMS Medicare Certification Letter'),
  ('AS', 'Ambulance Services - Basic Service'),
  ('AT', 'Ambulance Services - Advanced Life Support'),
  ('AU', 'Ambulance Services - Air Transport with FAA Air Worthiness Certificate'),
  ('AV', 'State License to operate as a Hospital'),
  ('AW', 'CMS PECOS Website Verification'),
  ('AX', 'CLIA Certificate if billing Lab Services'),
  ('AZ', 'Renal Dialysis Facility Approval letter from regional CMS office'),
  ('B0', 'Hospital Based Clinic Designation:  approval letter from CMS'),
  ('B1', 'Adult Day Care License'),
  ('B2', '245B License'),
  ('CA', 'Adult Rehabilitative Mental Health Services'),
  ('CB', 'Children''s Therapeutic Services and Supports (CTSS)'),
  ('CC', 'Adult Crisis Response Services - Crisis Assessment & Crisis Intervention'),
  ('CD', 'Adult Crisis Response Services - Crisis Stabilization'),
  ('CE', 'Adult Crisis Response Services - Short-Term Residential'),
  ('H1', 'Rehab Counselor Certification'),
  ('H2', 'Psychosocial Rehab Practitioner Certification'),
  ('H3', 'Licensed Practical Nurse'),
  ('L0', 'Marriage And Family Therapist'),
  ('L1', 'Audiologist License'),
  ('L2', 'Registration with the Department Of Health'),
  ('L3', 'Optometrist License'),
  ('L4', 'Registered Nurse'),
  ('L5', 'PCA Training Certificate'),
  ('L6', 'Traditional Midwife'),
  ('L7', 'MnSCU Certification'),
  ('L8', 'Chiropractic Examiner'),
  ('L9', 'License To Practice Podiatric Medicine'),
  ('M0', 'Hearing Aid Dispenser'),
  ('M1', 'Professional Clinical Counselor'),
  ('M2', 'Occupational Therapy'),
  ('M3', 'Physician Assistant'),
  ('M4', 'Physical Therapist'),
  ('M5', 'Speech Language Pathologist'),
  ('M6', 'Acupuncturist'),
  ('M7', 'Dental Hygienist'),
  ('M8', 'Mental Health Rehab Professional'),
  ('M9', 'Dental'),
  ('N1', 'Dietician or Nutritionist'),
  ('N2', 'Clinical Social Worker'),
  ('N3', 'Pharmacist License'),
  ('N4', 'Psychologist'),
  ('N5', 'Physician');

CREATE TABLE specialty_types(
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE,
  sub_category CHARACTER VARYING(2)
);
INSERT INTO specialty_types (code, description) VALUES
  ('01', 'Allergy'),
  ('02', 'Anesthesiology'),
  ('03', 'Cardiovascular Disease'),
  ('04', 'Cardiovascular Surgery'),
  ('05', 'Child Psychiatry'),
  ('06', 'Colon and Rectal Surgery'),
  ('07', 'Dermatology'),
  ('08', 'Diabetes'),
  ('09', 'Emergency Services'),
  ('10', 'Endocrinology'),
  ('11', 'Family Practice'),
  ('12', 'Gastroenterology'),
  ('13', 'General Practice'),
  ('14', 'General Surgery'),
  ('15', 'Gynecology'),
  ('16', 'Immunology'),
  ('17', 'Infectious Disease'),
  ('18', 'Internal Medicine'),
  ('19', 'Nephrology'),
  ('20', 'Neurological Surgery'),
  ('21', 'Neurology'),
  ('22', 'Nuclear Medicine'),
  ('23', 'Obstetrics'),
  ('24', 'Obstetrics and Gynecology'),
  ('25', 'Oncology'),
  ('26', 'Ophthalmology'),
  ('27', 'Pathology'),
  ('28', 'Peripheral Vascular Diseases or Surgery'),
  ('29', 'Physical Medicine and Rehabilitation'),
  ('30', 'Plastic Surgery'),
  ('31', 'Preventive Medicine'),
  ('32', 'Psychiatry'),
  ('33', 'Pulmonary Disease'),
  ('34', 'Radiology'),
  ('35', 'Radiology and Radiation Therapy'),
  ('36', 'Rheumatology'),
  ('37', 'Thoracic Surgery'),
  ('38', 'Urology'),
  ('39', 'Other'),
  ('41', 'Gerontological'),
  ('42', 'Pediatric'),
  ('43', 'Family'),
  ('44', 'Adult'),
  ('45', 'OB/GYN'),
  ('46', 'Neonatal'),
  ('47', 'Women''s Health Care'),
  ('48', 'Acute Care'),
  ('49', 'Gerontology'),
  ('50', 'Pediatrics'),
  ('C1', 'Adult CNS'),
  ('C2', 'Diabetes Management CNS'),
  ('C3', 'Gerontological CNS'),
  ('C4', 'Home Health CNS'),
  ('C5', 'Pediatric CNS'),
  ('D1', 'General Dentistry'),
  ('D2', 'Endodontist'),
  ('D3', 'Oral Surgery'),
  ('D4', 'Orthodontics'),
  ('D5', 'Pedodontics'),
  ('D6', 'Periodontics'),
  ('P1', 'Neuropsychology'),
  ('S1', 'CRNA Certification'),
  ('S2', 'Certified Professional Midwife'),
  ('S3', 'Psychiatric/Mental Health'),
  ('S6', 'Physical Rehabilitation'),
  ('S9', 'Certified Nurse Midwife');
INSERT INTO specialty_types (code, description, sub_category) VALUES
  ('FL', 'Fond Du Lac Indian Reservation', 'TC'),
  ('GP', 'Grand Portage Indian Reservation', 'TC'),
  ('LL', 'Leech Lake Indian Reservation', 'TC'),
  ('LS', 'Lower Sioux Indian Reservation', 'TC'),
  ('ML', 'Mille Lacs Indian Reservation', 'TC'),
  ('NL', 'Net Lake Indian Reservation', 'TC'),
  ('PI', 'Prairie Island Indian Reservation', 'TC'),
  ('RL', 'Red Lake Reservation', 'TC'),
  ('US', 'Upper Sioux Indian Reservation', 'TC'),
  ('WE', 'White Earth Indian Reservation', 'TC');

CREATE TABLE request_types(
  code CHARACTER VARYING(2) PRIMARY KEY,
  description TEXT UNIQUE
);
INSERT INTO request_types (code, description) VALUES
  ('01', 'Import Profile'),
  ('02', 'Enrollment'),
  ('03', 'Renewal'),
  ('04', 'Suspend'),
  ('05', 'Update');

CREATE TABLE states (
   code CHARACTER VARYING(2) PRIMARY KEY,
   description TEXT UNIQUE
);
INSERT INTO states (code, description) VALUES
  ('AK', 'Alaska'),
  ('AL', 'Alabama'),
  ('AR', 'Arkansas'),
  ('AZ', 'Arizona'),
  ('CA', 'California'),
  ('CO', 'Colorado'),
  ('CT', 'Connecticut'),
  ('DC', 'District of Columbia'),
  ('DE', 'Delaware'),
  ('FL', 'Florida'),
  ('GA', 'Georgia'),
  ('HI', 'Hawaii'),
  ('IA', 'Iowa'),
  ('ID', 'Idaho'),
  ('IL', 'Illinois'),
  ('IN', 'Indiana'),
  ('KS', 'Kansas'),
  ('KY', 'Kentucky'),
  ('LA', 'Louisiana'),
  ('MA', 'Massachusetts'),
  ('MD', 'Maryland'),
  ('ME', 'Maine'),
  ('MI', 'Michigan'),
  ('MN', 'Minnesota'),
  ('MO', 'Missouri'),
  ('MS', 'Mississippi'),
  ('MT', 'Montana'),
  ('NC', 'North Carolina'),
  ('ND', 'North Dakota'),
  ('NE', 'Nebraska'),
  ('NH', 'New Hampshire'),
  ('NJ', 'New Jersey'),
  ('NM', 'New Mexico'),
  ('NV', 'Nevada'),
  ('NY', 'New York'),
  ('OH', 'Ohio'),
  ('OK', 'Oklahoma'),
  ('OR', 'Oregon'),
  ('PA', 'Pennsylvania'),
  ('RI', 'Rhode Island'),
  ('SC', 'South Carolina'),
  ('SD', 'South Dakota'),
  ('TN', 'Tennessee'),
  ('TX', 'Texas'),
  ('UT', 'Utah'),
  ('VA', 'Virginia'),
  ('VT', 'Vermont'),
  ('WA', 'Washington'),
  ('WI', 'Wisconsin'),
  ('WV', 'West Virginia'),
  ('WY', 'Wyoming');

CREATE TABLE provider_profiles(
  control_no BIGINT PRIMARY KEY,
  profile_id BIGINT NOT NULL DEFAULT 0,
  ticket_id BIGINT NOT NULL DEFAULT 0,
  effective_date DATE,
  profile_status_code CHARACTER VARYING(2)
    REFERENCES profile_statuses(code),
  works_on_reservation CHARACTER VARYING(1),
  maintains_own_private_practice CHARACTER VARYING(1),
  employed_or_contracted_by_group CHARACTER VARYING(1),
  criminal_conviction CHARACTER VARYING(1),
  civil_penalty CHARACTER VARYING(1),
  previous_exclusion CHARACTER VARYING(1),
  employee_criminal_conviction CHARACTER VARYING(1),
  employee_civil_penalty CHARACTER VARYING(1),
  employee_previous_exclusion CHARACTER VARYING(1),
  adult CHARACTER VARYING(1),
  county TEXT,
  employed_since_clearance CHARACTER VARYING(1),
  risk_level_code CHARACTER VARYING(2)
    REFERENCES risk_levels(code),
  bed_count INTEGER,
  bed_count_title_18 INTEGER,
  bed_count_title_19 INTEGER,
  bed_count_dual_certified INTEGER,
  bed_count_icf INTEGER,
  bed_count_effective_date DATE,
  physical_and_occupational_therapy CHARACTER VARYING(1),
  reference_ticket_id BIGINT NOT NULL DEFAULT 0,
  owner_id TEXT,
  form_completed_by TEXT,
  health_board CHARACTER VARYING(1),
  created_by TEXT,
  created_at TIMESTAMP WITH TIME ZONE,
  last_modified_by TEXT,
  last_modified_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE addresses(
  address_id BIGINT PRIMARY KEY,
  attention_line TEXT,
  address_line_1 TEXT,
  address_line_2 TEXT,
  city TEXT,
  state TEXT,
  zip_code TEXT,
  county TEXT
);

CREATE TABLE agreement_documents(
  agreement_document_id BIGINT PRIMARY KEY,
  type TEXT,
  title TEXT,
  version INTEGER,
  body TEXT,
  created_by TEXT,
  created_at TIMESTAMP WITH TIME ZONE
);
INSERT INTO agreement_documents (
  agreement_document_id,
  type,
  title,
  version,
  body,
  created_by,
  created_at
) VALUES
  (1, '01', 'Agreement (1)', 0, 'This is the content of the agreement.', 'system', NOW()),
  (2, '02', 'Addendum (2)', 0, 'This is the content of the addendum.', 'system', NOW());

CREATE TABLE contacts(
  contact_id BIGINT PRIMARY KEY,
  phone_number TEXT,
  fax_number TEXT,
  email TEXT,
  address_id BIGINT
    REFERENCES addresses(address_id)
);

CREATE TABLE enrollments(
  enrollment_id BIGINT PRIMARY KEY,
  enrollment_status_code CHARACTER VARYING(2)
    REFERENCES enrollment_statuses(code),
  request_type_code CHARACTER VARYING(2)
    REFERENCES request_types(code),
  process_instance_id BIGINT NOT NULL DEFAULT 0,
  profile_reference_id BIGINT NOT NULL DEFAULT 0,
  reference_timestamp TIMESTAMP WITH TIME ZONE,
  progress_page TEXT,
  created_by TEXT,
  created_at TIMESTAMP WITH TIME ZONE,
  submitted_by TEXT,
  submitted_at TIMESTAMP WITH TIME ZONE,
  changed_by TEXT,
  changed_at TIMESTAMP WITH TIME ZONE,
  change_note TEXT
);

CREATE TABLE provider_type_agreement_documents(
  provider_type_code CHARACTER VARYING(2)
    REFERENCES provider_types(code),
  agreement_document_id BIGINT
    REFERENCES agreement_documents(agreement_document_id),
  PRIMARY KEY (provider_type_code, agreement_document_id)
);
INSERT INTO provider_type_agreement_documents (
  provider_type_code,
  agreement_document_id
) VALUES
  ('18', 1);

CREATE TABLE provider_type_license_types(
  provider_type_code CHARACTER VARYING(2)
    REFERENCES provider_types(code),
  license_type_code CHARACTER VARYING(2)
    REFERENCES license_types(code),
  PRIMARY KEY (provider_type_code, license_type_code)
);
INSERT INTO provider_type_license_types(
  provider_type_code,
  license_type_code
) VALUES
  ('01', 'L1'),
  ('01', 'L2'),
  ('02', 'L3'),
  ('03', 'L4'),
  ('04', 'L5'),
  ('05', 'L6'),
  ('06', 'L7'),
  ('07', 'L4'),
  ('08', 'L8'),
  ('09', 'L9'),
  ('10', 'L0'),
  ('11', 'M1'),
  ('12', 'L4'),
  ('13', 'M2'),
  ('14', 'M3'),
  ('15', 'H3'),
  ('15', 'A9'),
  ('15', 'L4'),
  ('16', 'M4'),
  ('17', 'M5'),
  ('18', 'M6'),
  ('19', 'M7'),
  ('20', 'H1'),
  ('20', 'H2'),
  ('20', 'M8'),
  ('21', 'M9'),
  ('22', 'M0'),
  ('23', 'N1'),
  ('24', 'N2'),
  ('25', 'L4'),
  ('26', 'N3'),
  ('27', 'N4'),
  ('28', 'N5');

CREATE TABLE entities(
  entity_id BIGINT PRIMARY KEY,
  enrolled CHARACTER VARYING(1),
  profile_id BIGINT NOT NULL,
  ticket_id BIGINT,
  name TEXT,
  legal_name TEXT,
  legacy_indicator CHARACTER VARYING(1),
  legacy_id TEXT,
  npi TEXT,
  npi_verified CHARACTER VARYING(1),
  npi_lookup_verified CHARACTER VARYING(1),
  nonexclusion_verified CHARACTER VARYING(1),
  provider_type_code CHARACTER VARYING(2)
    REFERENCES provider_types(code),
  provider_sub_type TEXT,
  contact_id BIGINT
    REFERENCES contacts(contact_id),
  background_study_id TEXT,
  background_clearance_date TIMESTAMP WITH TIME ZONE
);
CREATE TABLE organizations(
  entity_id BIGINT PRIMARY KEY
    REFERENCES entities(entity_id),
  fein CHARACTER VARYING(10),
  agency_id TEXT,
  billing_same_as_primary CHARACTER VARYING(1),
  reimbursement_same_as_primary CHARACTER VARYING(1),
  ten99_same_as_primary CHARACTER VARYING(1),
  billing_address_id BIGINT
    REFERENCES addresses(address_id),
  reimbursement_address_id BIGINT
    REFERENCES addresses(address_id),
  ten99_address_id BIGINT
    REFERENCES addresses(address_id),
  state_tax_id TEXT,
  fiscal_year_end TEXT,
  remittance_sequence_order TEXT,
  eft_vendor_number TEXT
);
CREATE TABLE people(
  entity_id BIGINT PRIMARY KEY
    REFERENCES entities(entity_id),
  prefix TEXT,
  first_name TEXT,
  middle_name TEXT,
  last_name TEXT,
  suffix TEXT,
  ssn TEXT,
  ssn_verified CHARACTER VARYING(1),
  birth_date DATE,
  degree_code CHARACTER VARYING(2)
    REFERENCES degrees(code),
  degree_award_date DATE
);

CREATE TABLE binary_contents(
  binary_content_id TEXT PRIMARY KEY,
  content OID
);

CREATE TABLE documents(
  document_id BIGINT PRIMARY KEY,
  profile_id BIGINT,
  ticket_id BIGINT,
  "type" TEXT,
  filename TEXT,
  description TEXT,
  binary_content_id TEXT,
  created_by TEXT,
  created_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE designated_contacts(
  designated_contact_id BIGINT PRIMARY KEY,
  profile_id BIGINT,
  ticket_id BIGINT,
  designated_contact_type TEXT,
  same_as_provider CHARACTER VARYING(1),
  hired_at DATE,
  person_id BIGINT
    REFERENCES people(entity_id)
);

CREATE TABLE accepted_agreements(
  accepted_agreement_id BIGINT PRIMARY KEY,
  profile_id BIGINT,
  ticket_id BIGINT,
  accepted_date DATE,
  agreement_document_id BIGINT
    REFERENCES  agreement_documents(agreement_document_id)
 ) ;

CREATE TABLE screening_schedules(
  screening_schedule_id BIGINT PRIMARY KEY,
  upcoming_screening_date DATE,
  interval_type TEXT,
  interval_value BIGINT NOT NULL
);

INSERT INTO screening_schedules(
  screening_schedule_id,
  upcoming_screening_date,
  interval_type,
  interval_value
) VALUES
  (1, null, null, 0);

CREATE TABLE licenses(
  license_id BIGINT PRIMARY KEY,
  profile_id BIGINT,
  ticket_id BIGINT,
  affiliate_id BIGINT,
  object_type TEXT,
  license_number TEXT,
  issued_at DATE,
  expires_at DATE,
  issuing_us_state TEXT,
  issuing_board_code CHARACTER VARYING(2)
    REFERENCES issuing_boards(code),
  license_status_code CHARACTER VARYING(2)
    REFERENCES license_statuses(code),
  license_type_code CHARACTER VARYING(2)
    REFERENCES license_types(code),
  specialty_type_code CHARACTER VARYING(2)
    REFERENCES specialty_types(code),
  attachment_id BIGINT
);

CREATE TABLE affiliations(
  affiliation_id BIGINT PRIMARY KEY,
  is_primary CHARACTER VARYING(1),
  profile_id BIGINT,
  object_type TEXT,
  ticket_id BIGINT,
  effective_at DATE,
  target_profile_id BIGINT,
  target_entity_id BIGINT,
  qualified_professional_type_code CHARACTER VARYING(2)
    REFERENCES qualified_professional_types(code),
  mental_health_professional_type TEXT,
  acknowledgement_attachment_id TEXT,
  is_terminated CHARACTER VARYING(1),
  terminated_at DATE,
  bgs_study_id TEXT,
  bgs_clearance_date DATE
);

CREATE TABLE provider_statements(
  provider_statement_id BIGINT PRIMARY KEY,
  profile_id BIGINT,
  ticket_id BIGINT,
  name TEXT,
  title TEXT,
  "date" DATE
);

  CREATE TABLE assured_services (
    assured_service_id BIGINT PRIMARY KEY ,
    effective_date DATE,
    service_assurance_code CHARACTER VARYING(2) REFERENCES service_assurance_types(code),
    profile_id BIGINT,
    ticket_id BIGINT,
    status INTEGER
   ) ;

CREATE TABLE beneficial_owner (
  beneficial_owner_id       BIGINT PRIMARY KEY,
  person_ind                CHARACTER VARYING(1),
  ben_type_cd               CHARACTER VARYING(2)
    REFERENCES beneficial_owner_types (code),
  oth_type_desc             TEXT,
  subcontractor_name        TEXT,
  own_interest_pct          FLOAT,
  address_id                BIGINT
    REFERENCES addresses (address_id),
  oth_provider_interest_ind TEXT,
  oth_provider_name         TEXT,
  oth_provider_own_pct      FLOAT,
  oth_provider_address_id   BIGINT
    REFERENCES addresses(address_id),
  middle_name               TEXT,
  first_name                TEXT,
  last_name                 TEXT,
  ssn                       TEXT,
  birth_dt                  DATE,
  hired_at                  DATE,
  relationship_type_code    CHARACTER VARYING(2)
    REFERENCES relationship_types (code),
  ownership_info_id         BIGINT,
  fein                      CHARACTER VARYING(20),
  legal_name                TEXT
);

CREATE TABLE owner_assets(
  owner_asset_id BIGINT PRIMARY KEY ,
  name TEXT,
  ownership_type_code CHARACTER VARYING(2)
    REFERENCES  ownership_types(code),
  address_id BIGINT
    REFERENCES addresses(address_id),
  ownership_info_id BIGINT
) ;
