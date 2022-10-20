// fbi.gov json data files
String jsonTestData = 'fbi_wanted.json';

// FBI Wanted list API
const String fbiWantedListApi = 'https://api.fbi.gov/wanted/v1/list';
const String fbiWantedListApiAuthority = 'api.fbi.gov';
const String fbiWantedListApiUrl = 'wanted/v1/list';

const List<String> fbiSearchFields = [
  "field_offices",
  "title",
  // "uid",
  "race",
  "hair",
  "eyes",
  // "status"
];

const Map<String, dynamic> initialFbiWantedJson = {
  "total": -1,
  "items": [
    {
      "files": [
        {
          "url":
              "https://www.fbi.gov/wanted/law-enforcement-assistance/arthur-henry-disanto-jr/download.pdf",
          "name": "English"
        }
      ],
      "age_range": "",
      "uid": "8b40c85a2cb947ecb9cc33742b812e6a",
      "weight": "215 pounds",
      "occupations": [],
      "field_offices": ["philadelphia"],
      "locations": [],
      "reward_text": "",
      "hair": "brown",
      "ncic": "",
      "dates_of_birth_used": ["May 19, 1980"],
      "caution": "",
      "nationality": "",
      "age_min": 0,
      "age_max": 0,
      "scars_and_marks": "Disanto, Jr. has tattoos on both of his arms.",
      "subjects": ["Law Enforcement Assistance"],
      "aliases": [],
      "race_raw": "White",
      "suspects": [],
      "publication": "2021-08-06T10:22:00",
      "title": "ARTHUR HENRY DISANTO, JR.",
      "coordinates": [],
      "hair_raw": "Brown (Balding)",
      "languages": [],
      "complexion": "",
      "build": "",
      "details":
          "<p>The FBI Philadelphia Field Office is assisting the Pennsylvania State Police with the search for Arthur Henry Disanto, Jr.  Disanto, Jr. is wanted for attempted homicide for allegedly shooting a woman in her Media, Pennsylvania, apartment in the early morning hours of July 3, 2021.</p>\r\n<p> </p>\r\n<p>On July 3, 2021, Disanto, Jr. was charged with attempted homicide and related offenses in the 32nd Judicial District in Delaware County, Pennsylvania, and a state warrant was issued for his arrest.</p>\r\n<p> </p>",
      "status": "na",
      "legat_names": [],
      "eyes": "brown",
      "person_classification": "Main",
      "description":
          "Attempted Homicide; Aggravated Assault; Simple Assault; Harassment",
      "images": [
        {
          "large":
              "https://www.fbi.gov/wanted/law-enforcement-assistance/arthur-henry-disanto-jr/@@images/image/large",
          "caption": "",
          "thumb":
              "https://www.fbi.gov/wanted/law-enforcement-assistance/arthur-henry-disanto-jr/@@images/image/thumb",
          "original":
              "https://www.fbi.gov/wanted/law-enforcement-assistance/arthur-henry-disanto-jr/@@images/image"
        }
      ],
      "possible_countries": [],
      "weight_min": 0,
      "additional_information": "",
      "remarks": "",
      "path": "/wanted/law-enforcement-assistance/arthur-henry-disanto-jr",
      "sex": "Male",
      "eyes_raw": "Brown",
      "weight_max": 0,
      "reward_min": 0,
      "url":
          "https://www.fbi.gov/wanted/law-enforcement-assistance/arthur-henry-disanto-jr",
      "possible_states": [],
      "modified": "2021-08-06T15:45:41+00:00",
      "reward_max": 0,
      "race": "white",
      "height_max": 0,
      "place_of_birth": "",
      "height_min": 0,
      "warning_message": "SHOULD BE CONSIDERED ARMED AND DANGEROUS",
      "@id":
          "https://api.fbi.gov/@wanted-person/8b40c85a2cb947ecb9cc33742b812e6a"
    }
  ],
  "photo_url":
      "https://www.fbi.gov/contact-us/field-offices/albany/@@images/image/preview"
};

const Map<String, dynamic> fieldOffices = {
  "total": 56,
  "updated": "August 12, 2021",
  "field_offices": [
    {
      "office": "headquarters",
      "address": "935 Pennsylvania Avenue NW",
      "city": "Washington HQ",
      "state": "District of Columbia",
      "state_code": "DC",
      "postal_code": "20535",
      "website": "https://www.fbi.gov/contact-us/fbi-headquarters",
      "phone": "(202) 324-3000",
      "counties": [],
      "photo_url":
          "https://www.fbi.gov/contact-us/fbi-headquarters/flags-and-banners-at-fbi-headquarters/@@images/image/preview"
    },
    {
      "office": "albany",
      "city": "Albany",
      "address": "200 McCarty Avenue",
      "state": "New York",
      "state_code": "NY",
      "postal_code": "12209",
      "website": "https://albany.fbi.gov",
      "phone": "(518) 465-7551",
      "counties": [
        "Albany",
        "Fulton",
        "Hamilton",
        "Montgomery",
        "Rensselaer",
        "Saratoga",
        "Schenectady",
        "Schoharie",
        "Warren",
        "Washington"
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/albany/@@images/image/large"
    },
    {
      "office": "albuquerque",
      "address": "4200 Luecking Park Avenue NE",
      "city": "Albuquerque",
      "state": "New Mexico",
      "state_code": "NM",
      "postal_code": "87107",
      "website": "https://albuquerque.fbi.gov",
      "phone": "(505) 889-1300",
      "counties": [
        "Bernalillo",
        "Catron",
        "Cibola (eastern half)",
        "Guadalupe",
        "Quay",
        "Sandoval (southern corner)",
        "Socorro",
        "Torrence",
        "Valencia"
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/albuquerque/@@images/image/preview"
    },
    {
      "office": "anchorage",
      "address": "101 East Sixth Avenue",
      "city": "Anchorage",
      "state": "Alaska",
      "state_code": "AK",
      "postal_code": "99501",
      "website": "https://anchorage.fbi.gov",
      "phone": "(907) 276-4441",
      "counties": ["All Counties"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/anchorage/@@images/image/preview"
    },
    {
      "office": "atlanta",
      "address": "3000 Flowers Road S",
      "city": "Atlanta",
      "state": "Georgia",
      "state_code": "GA",
      "postal_code": "30341",
      "website": "https://atlanta.fbi.gov",
      "phone": "(770) 216-3000",
      "counties": ["All Counties"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/atlanta/@@images/image/large"
    },
    {
      "office": "baltimore",
      "address": "2600 Lord Baltimore Drive",
      "city": "Baltimore",
      "state": "Maryland",
      "state_code": "MD",
      "postal_code": "21244",
      "website": "https://baltimore.fbi.gov",
      "phone": "(410) 265-8080",
      "counties": ["All Maryland Counties", "All Delaware Counties"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/baltimore/@@images/image/preview"
    },
    {
      "office": "birmingham",
      "address": "1000 18th Street North",
      "city": "Birmingham",
      "state": "Alabama",
      "state_code": "AL",
      "postal_code": "35203",
      "website": "https://birmingham.fbi.gov",
      "phone": "(205) 326-6166",
      "counties": ["Northern District of Alabama"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/birmingham/@@images/image/large"
    },
    {
      "office": "boston",
      "address": "201 Maple Street",
      "city": "Chelsea",
      "state": "Massachusetts",
      "state_code": "MA",
      "postal_code": "02150",
      "website": "https://boston.fbi.gov",
      "phone": "(857) 386-2000",
      "counties": [
        "All Maine Counties",
        "All Massachusetts Counties",
        "All New Hampshire Counties",
        "All Rhode Island Counties"
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/boston/@@images/image/preview"
    },
    {
      "office": "buffalo",
      "address": "One FBI Plaza",
      "city": "Buffalo",
      "state": "New York",
      "state_code": "NY",
      "postal_code": "14202",
      "website": "https://buffalo.fbi.gov",
      "phone": "(716) 856-7800",
      "counties": ["Covers 17 counties in western New York"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/buffalo/@@images/image/preview"
    },
    {
      "office": "charlotte",
      "address": "7915 Microsoft Way",
      "city": "Charlotte",
      "state": "North Carolina",
      "state_code": "NC",
      "postal_code": "28273",
      "website": "https://charlotte.fbi.gov",
      "phone": "(704) 672-6100",
      "counties": ["All counties in North Carolina"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/charlotte/@@images/image/large"
    },
    {
      "office": "chicago",
      "address": "2111 W. Roosevelt Road",
      "city": "Chicago",
      "state": "Illinois",
      "state_code": "IL",
      "postal_code": "60608",
      "website": "https://chicago.fbi.gov",
      "phone": "(312) 421-6700",
      "counties": [
        "Covers 18 counties in northern Illinois extending from Interstate 80 north to the Wisconsin border, east to Indiana, and west to Iowa"
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/chicago/@@images/image/preview"
    },
    {
      "office": "cincinnati",
      "address": "2012 Ronald Reagan Drive",
      "city": "Cincinnati",
      "state": "Ohio",
      "state_code": "OH",
      "postal_code": "45236",
      "website": "https://cincinnati.fbi.gov",
      "phone": "(513) 421-4310",
      "counties": ["Covers 48 counties throughout central and southern Ohio"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/cincinnati/@@images/image/large"
    },
    {
      "office": "cleveland",
      "address": "1501 Lakeside Avenue",
      "city": "Cleveland",
      "state": "Ohio",
      "state_code": "OH",
      "postal_code": "44114",
      "website": "https://cleveland.fbi.gov",
      "phone": "(216) 522-1400",
      "counties": ["Covers 40 counties in Ohio"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/cleveland/@@images/image/large"
    },
    {
      "office": "columbia",
      "address": "151 Westpark Boulevard",
      "city": "Columbia",
      "state": "South Carolina",
      "state_code": "SC",
      "postal_code": "29210",
      "website": "https://columbia.fbi.gov",
      "phone": "(803) 551-4200",
      "counties": ["Covers the entire state of South Carolina"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/columbia/@@images/image/large"
    },
    {
      "office": "dallas",
      "address": "One Justice Way",
      "city": "Dallas",
      "state": "Texas",
      "state_code": "TX",
      "postal_code": "75220",
      "website": "https://dallas.fbi.gov",
      "phone": "(972) 559-5000",
      "counties": [
        "Covers 137 counties in North Texas and portions of Eaast and West Texas"
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/dallas/@@images/image/preview"
    },
    {
      "office": "denver",
      "address": "8000 East 36th Avenue",
      "city": "Denver",
      "state": "Colorado",
      "state_code": "CO",
      "postal_code": "80238",
      "website": "https://denver.fbi.gov",
      "phone": "(303) 629-7171",
      "counties": ["Covers the entire states of Colorado and Wyoming"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/denver/@@images/image/preview"
    },
    {
      "office": "detroit",
      "address": "477 Michigan Ave., 26th Floor",
      "city": "Detroit",
      "state": "Michigan",
      "state_code": "MI",
      "postal_code": "48226",
      "website": "https://detroit.fbi.gov",
      "phone": "(313) 965-2323",
      "counties": [
        "Covers the entire state of Michigan, including the Upper Peninsula"
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/detroit/@@images/image/preview"
    },
    {
      "office": "elpaso",
      "address": "El Paso Federal Justice Center",
      "city": "El Paso",
      "state": "Texas",
      "state_code": "TX",
      "postal_code": "79912",
      "website": "https://elpaso.fbi.gov",
      "phone": "(915) 832-5000",
      "counties": ["Covers 17 counties in western Texas"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/elpaso/@@images/image/preview"
    },
    {
      "office": "honolulu",
      "address": "91-1300 Enterprise Street",
      "city": "Honolulu",
      "state": "Hawaii",
      "state_code": "HI",
      "postal_code": "96707",
      "website": "https://honolulu.fbi.gov",
      "phone": "(808) 566-4300",
      "counties": ["Covers the state of Hawaii along with Guam and Saipan"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/honolulu/@@images/image/preview"
    },
    {
      "office": "houston",
      "address": "1 Justice Park Drive",
      "city": "Houston",
      "state": "Texas",
      "state_code": "TX",
      "postal_code": "77292",
      "website": "https://houston.fbi.gov",
      "phone": "(713) 693-5000",
      "counties": ["Covers 40 counties in southeastern Texas"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/houston/@@images/image/large"
    },
    {
      "office": "indianapolis",
      "address": "8825 Nelson B Klein Pkwy",
      "city": "Indianapolis",
      "state": "Indiana",
      "state_code": "IN",
      "postal_code": "46250",
      "website": "https://indianapolis.fbi.gov",
      "phone": "(317) 595-4000",
      "counties": ["Covers the entire state of Indiana"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/indianapolis/@@images/image/preview"
    },
    {
      "office": "jackson",
      "address": "1220 Echelon Parkway",
      "city": "Jackson",
      "state": "Mississippi",
      "state_code": "MS",
      "postal_code": "39213",
      "website": "https://jackson.fbi.gov",
      "phone": "(601) 948-5000",
      "counties": ["Covers the entire state of Mississippi"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/jackson/@@images/image/preview"
    },
    {
      "office": "jacksonville",
      "address": "6061 Gate Parkway",
      "city": "Jacksonville",
      "state": "Florida",
      "state_code": "FL",
      "postal_code": "32256",
      "website": "https://jacksonville.fbi.gov",
      "phone": "(904) 248-7000",
      "counties": ["Covers 40 counties throughout northern Florida"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/jacksonville/@@images/image/preview"
    },
    {
      "office": "kansascity",
      "address": "1300 Summit Street",
      "city": "Kansas City",
      "state": "Missouri",
      "state_code": "MO",
      "postal_code": "64105",
      "website": "https://kansascity.fbi.gov",
      "phone": "(816) 512-8200",
      "counties": [
        "Covers the Western District of Missouri and the entire state of Kansas"
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/kansascity/@@images/image/large"
    },
    {
      "office": "knoxville",
      "address": "1501 Dowell Springs Boulevard",
      "city": "Knoxville",
      "state": "Tennessee",
      "state_code": "TN",
      "postal_code": "37909",
      "website": "https://knoxvill.fbi.gov",
      "phone": "(865) 544-0751",
      "counties": ["Covers 41 counties in eastern Tennessee"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/knoxville/@@images/image/preview"
    },
    {
      "office": "lasvegas",
      "address": "1787 West Lake Mead Boulevard",
      "city": "Las Vegas",
      "state": "Nevada",
      "state_code": "NV",
      "postal_code": "89106-2135",
      "website": "https://lasvegas.fbi.gov",
      "phone": "(702) 385-1281",
      "counties": ["Covers the entire state of Nevada"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/lasvegas/@@images/image/preview"
    },
    {
      "office": "littlerock",
      "address": "24 Shackleford West Boulevard",
      "city": "Little Rock",
      "state": "Arkansas",
      "state_code": "AR",
      "postal_code": "72211",
      "website": "https://littlerock.fbi.gov",
      "phone": "(501) 221-9100",
      "counties": ["Covers the entire state of Arkansas"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/littlerock/@@images/image/large"
    },
    {
      "office": "losangeles",
      "address": "11000 Wilshire Boulevard",
      "city": "Los Angeles",
      "state": "California",
      "state_code": "CA",
      "postal_code": "90024",
      "website": "https://losangeles.fbi.gov",
      "phone": "(310) 477-6565",
      "counties": ["Covers the Central District of California"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/losangeles/@@images/image/preview"
    },
    {
      "office": "louisville",
      "address": "12401 Sycamore Station Place",
      "city": "Louisville",
      "state": "Kentucky",
      "state_code": "KY",
      "postal_code": "40299-6198",
      "website": "https://louisville.fbi.gov",
      "phone": "(502) 263-6000",
      "counties": ["Covers the entire state Kentucky"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/louisville/@@images/image/preview"
    },
    {
      "office": "memphis",
      "address": "225 North Humphreys Boulevard, Suite 3000",
      "city": "Memphis",
      "state": "Tennessee",
      "state_code": "TN",
      "postal_code": "38120",
      "website": "https://memphis.fbi.gov",
      "phone": "(901) 747-4300",
      "counties": ["Covers 54 counties in western Tennessee"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/memphis/@@images/image/large"
    },
    {
      "office": "miami",
      "address": "2030 SW 145th Avenue",
      "city": "Miami",
      "state": "Florida",
      "state_code": "FL",
      "postal_code": "33027",
      "website": "https://miami.fbi.gov",
      "phone": "(754) 703-2000",
      "counties": [
        "Covers nine counties in southern Florida and responsible for addressing extraterritorial violations of American citizens in Mexico, the Caribbean, and Central and South America"
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/miami/@@images/image/preview"
    },
    {
      "office": "milwaukee",
      "address": "3600 S. Lake Drive",
      "city": "Milwaukee",
      "state": "Wisconsin",
      "state_code": "WI",
      "postal_code": "53235",
      "website": "https://milwaukee.fbi.gov",
      "phone": "(414) 276-4684",
      "counties": ["Covers the entire state of Wisconsin"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/milwaukee/@@images/image/preview"
    },
    {
      "office": "minneapolis",
      "address": "1501 Freeway Boulevard",
      "city": "Minneapolis",
      "state": "Minnesota",
      "state_code": "MN",
      "postal_code": "55430",
      "website": "https://minneapolis.fbi.gov",
      "phone": "(763) 569-8000",
      "counties": [
        "Covers the entire states of Minnesota, North Dakota, and South Dakota"
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/minneapolis/@@images/image/preview"
    },
    {
      "office": "mobile",
      "address": "200 North Royal Street",
      "city": "Mobile",
      "state": "Alabama",
      "state_code": "AL",
      "postal_code": "36602",
      "website": "https://mobile.fbi.gov",
      "phone": "(251) 438-3674",
      "counties": [
        "Covers the Middle Judicial District of Alabama and the Southern Judicial District of Alabama"
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/mobile/@@images/image/preview"
    },
    {
      "office": "newhaven",
      "address": "600 State Street",
      "city": "New Haven",
      "state": "Connecticut",
      "state_code": "CT",
      "postal_code": "06511",
      "website": "https://newhaven.fbi.gov",
      "phone": "(203) 777-6311",
      "counties": ["Covers the entire state of Connecticut"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/newhaven/@@images/image/large"
    },
    {
      "office": "neworleans",
      "address": "2901 Leon C. Simon Boulevard",
      "city": "New Orleans",
      "state": "Louisiana",
      "state_code": "LA",
      "postal_code": "70126",
      "website": "https://neworleans.fbi.gov",
      "phone": "(504) 816-3000",
      "counties": ["Covers the entire state of Louisiana"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/neworleans/@@images/image/preview"
    },
    {
      "office": "newyork",
      "address": "26 Federal Plaza, 23rd Floor",
      "city": "New York",
      "state": "New York",
      "state_code": "NY",
      "postal_code": "10278-0004",
      "website": "https://newyork.fbi.gov",
      "phone": "(212) 384-1000",
      "counties": [
        "Covers the five boroughs of New York City, eight counties in New York state, and La Guardia Airport and John F. Kennedy International Airport"
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/newyork/@@images/image/large"
    },
    {
      "office": "newark",
      "address": "Claremont Tower, 11 Centre Place",
      "city": "Newark",
      "state": "New Jersey",
      "state_code": "NJ",
      "postal_code": "07102",
      "website": "https://newark.fbi.gov",
      "phone": "(973) 792-3000",
      "counties": [
        "Covers the state of New Jersey except for three counties covered by FBI Philadelphia (Camden, Gloucester, and Salem)"
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/newark/@@images/image/preview"
    },
    {
      "office": "norfolk",
      "address": "509 Resource Row",
      "city": "Norfolk",
      "state": "Vrginia",
      "state_code": "VA",
      "postal_code": "23320",
      "website": "https://norfolk.fbi.gov",
      "phone": "(757) 455-0100",
      "counties": [
        "Covers the southeastern part of Virginia, including the Southside, Peninsula, and the Virginia Eastern Shore"
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/norfolk/@@images/image/preview"
    },
    {
      "office": "oklahomacity",
      "address": "3301 West Memorial Road",
      "city": "Oklahoma City",
      "state": "Oklahoma",
      "state_code": "OK",
      "postal_code": "73134-7098",
      "website": "https://oklahomacity.fbi.gov",
      "phone": "(405) 290-7770",
      "counties": ["Covers the entire state of Oklahoma"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/oklahomacity/@@images/image/preview"
    },
    {
      "office": "omaha",
      "address": "4411 South 121st Court",
      "city": "Omaha",
      "state": "Nebraska",
      "state_code": "NE",
      "postal_code": "68137-2112",
      "website": "https://omaha.fbi.gov",
      "phone": "(402) 493-8688",
      "counties": ["Covers the entire states of Nebraska and Iowa"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/omaha/@@images/image/preview"
    },
    {
      "office": "philadelphia",
      "address": "William J. Green, Jr. Building, 600 Arch Street, 8th Floor",
      "city": "Philadelphia",
      "state": "Pennsylvania",
      "state_code": "PA",
      "postal_code": "19106",
      "website": "https://philadelphia.fbi.gov",
      "phone": "(215) 418-4000",
      "counties": [
        "Covers eastern Pennsylvania and three counties in New Jersey"
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/philadelphia/@@images/image/preview"
    },
    {
      "office": "phoenix",
      "address": "21711 N. 7th Street",
      "city": "Phoenix",
      "state": "Arizona",
      "state_code": "AZ",
      "postal_code": "85024",
      "website": "https://phoenix.fbi.gov",
      "phone": "(623) 466-1999",
      "counties": [
        "Covers the entire state of Arizona and Grand Canyon National Park"
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/phoenix/@@images/image/large"
    },
    {
      "office": "pittsburgh",
      "address": "3311 East Carson Street",
      "city": "Pittsburgh",
      "state": "Pennsylvania",
      "state_code": "PA",
      "postal_code": "15203",
      "website": "https://pittsburgh.fbi.gov",
      "phone": "(412) 432-4000",
      "counties": [
        "Covers 25 counties in western Pennsylvania as well as the entire state of West Virginia"
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/pittsburgh/@@images/image/preview"
    },
    {
      "office": "portland",
      "address": "9109 NE Cascades Parkway",
      "city": "Portland",
      "state": "Oregon",
      "state_code": "OR",
      "postal_code": "97220",
      "website": "https://portland.fbi.gov",
      "phone": "(503) 224-4181",
      "counties": ["Covers the entire state of Oregon"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/portland/@@images/image/preview"
    },
    {
      "office": "richmond",
      "address": "1970 East Parham Road",
      "city": "Richmond",
      "state": "Virginia",
      "state_code": "VA",
      "postal_code": "23228",
      "website": "https://richmond.fbi.gov",
      "phone": "(804) 261-1044",
      "counties": [
        "Covers most of the state of Virginia—82 counties and 24 independent cities—except Northern Virginia and the Eastern Shore."
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/richmond/@@images/image/preview"
    },
    {
      "office": "sacramento",
      "address": "2001 Freedom Way",
      "city": "Sacramento",
      "state": "California",
      "state_code": "CA",
      "postal_code": "95678",
      "website": "https://sacramento.fbi.gov",
      "phone": "(916) 746-7000",
      "counties": [
        "Along with our main office in Roseville, we have eight satellite offices, known as resident agencies, in the area"
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/sacramento/@@images/image/preview"
    },
    {
      "office": "saltlakecity",
      "address": "5425 West Amelia Earhart Drive",
      "city": "Salt Lake City",
      "state": "Utah",
      "state_code": "UT",
      "postal_code": "84116",
      "website": "https://saltlakecity.fbi.gov",
      "phone": "(801) 579-1400",
      "counties": ["Covers the entire states of Utah, Idaho, and Montana"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/saltlakecity/@@images/image/high"
    },
    {
      "office": "sanantonio",
      "address": "5740 University Heights Blvd.",
      "city": "San Antonio",
      "state": "Texas",
      "state_code": "TX",
      "postal_code": "78249",
      "website": "https://sanantonio.fbi.gov",
      "phone": "(210) 225-6741",
      "counties": [
        "Atascosa",
        "Bandera",
        "Bexar",
        "Comal",
        "Frio",
        "Gillespie",
        "Gonzalez",
        "Guadalupe",
        "Karnes",
        "Kendall",
        "Kerr",
        "Kimble",
        "Mason",
        "Medina",
        "Real",
        "Uvalde",
        "Wilson"
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/sanantonio/@@images/image/high"
    },
    {
      "office": "sandiego",
      "address": "10385 Vista Sorrento Parkway",
      "city": "San Diego",
      "state": "California",
      "state_code": "CA",
      "postal_code": "92121",
      "website": "https://sandiego.fbi.gov",
      "phone": "(858) 320-1800",
      "counties": [
        "Covers San Diego and Imperial Counties in southern California"
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/sandiego/@@images/image/high"
    },
    {
      "office": "sanfrancisco",
      "address": "450 Golden Gate Avenue, 13th Floor",
      "city": "San Francisco",
      "state": "California",
      "state_code": "CA",
      "postal_code": "94102-9523",
      "website": "https://sanfrancisco.fbi.gov",
      "phone": "(415) 553-7400",
      "counties": [
        "Along with our main office in San Francisco, we have seven satellite offices in the area"
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/sanfrancisco/@@images/image/preview"
    },
    {
      "office": "sanjuan",
      "address": "140 Carlos Chardon Avenue",
      "city": "San Juan",
      "state": "Puerto Rico",
      "state_code": "PR",
      "postal_code": "00918",
      "website": "https://sanjuan.fbi.gov",
      "phone": "(787) 987-6500",
      "counties": ["Covers Puerto Rico and the U.S. Virgin Islands"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/sanjuan/@@images/image/preview"
    },
    {
      "office": "seattle",
      "address": "1110 3rd Avenue",
      "city": "Seattle",
      "state": "Washington",
      "state_code": "WA",
      "postal_code": "98101-2904",
      "website": "https://seattle.fbi.gov",
      "phone": "(206) 622-0460",
      "counties": ["Covers the entire state of Washington"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/seattle/@@images/image/preview"
    },
    {
      "office": "springfield",
      "address": "900 East Linton Avenue",
      "city": "Springfield",
      "state": "Illinois",
      "state_code": "IL",
      "postal_code": "62703",
      "website": "https://springfield.fbi.gov",
      "phone": "(217) 522-9675",
      "counties": ["Covers central and southern Illinois"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/springfield/@@images/image/preview"
    },
    {
      "office": "stlouis",
      "address": "2222 Market Street",
      "city": "St. Louis",
      "state": "Missouri",
      "state_code": "MO",
      "postal_code": "63103",
      "website": "https://stlouis.fbi.gov",
      "phone": "(314) 589-2500",
      "counties": ["Covers the Eastern District of Missouri"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/stlouis/@@images/image/preview"
    },
    {
      "office": "tampa",
      "address": "5525 West Gray Street",
      "city": "Tampa",
      "state": "Florida",
      "state_code": "FL",
      "postal_code": "33609",
      "website": "https://tampa.fbi.gov",
      "phone": "(813) 253-1000",
      "counties": ["Covers 18 counties in central and southwest Florida"],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/tampa/@@images/image/preview"
    },
    {
      "office": "washingtondc",
      "address": "601 4th Street NW",
      "city": "Washington DC",
      "state": "District of Columbia",
      "state_code": "DC",
      "postal_code": "20535",
      "website": "https://washingtondc.fbi.gov",
      "phone": "(202) 278-2000",
      "counties": [
        "Covers the District of Columbia and several counties in Northern Virginia"
      ],
      "photo_url":
          "https://www.fbi.gov/contact-us/field-offices/washingtondc/@@images/image/preview"
    }
  ]
};
