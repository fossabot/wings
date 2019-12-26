// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
// Source: examples/input/student.wings

import People from './People';
import Homework from './Homework';
import Emotion from './person/Emotion';

// Any person who is studying in a class
export default class Student implements People {
    [key: string]: any;
    public ID: number = -1;
    public name: string = '';
    public curClass: string = '';
    public feeling: Emotion = Emotion.Meh;
    public isActive: boolean = true;
    public year: Date = new Date();
    public graduation: Date = new Date();
    public homeworks: Homework[] = [];
    public something: Map<string, string> = new Map<string, string>();

    public init(data: any): boolean {
        try {
            this.ID = data.id;
            this.name = data.name;
            this.curClass = data.cur_class;
            this.feeling = data.feeling;
            this.isActive = data.is_active;
            this.year = data.year;
            this.graduation = data.graduation;
            this.homeworks = data.homeworks;
            this.something = data.something;
        } catch (e) {
            return false;
        }
        return true;
    }

    public toJsonKey(key: string): string {
        switch (key) {
            case 'ID': {
                return 'id';
            }
            case 'name': {
                return 'name';
            }
            case 'curClass': {
                return 'cur_class';
            }
            case 'feeling': {
                return 'feeling';
            }
            case 'isActive': {
                return 'is_active';
            }
            case 'year': {
                return 'year';
            }
            case 'graduation': {
                return 'graduation';
            }
            case 'homeworks': {
                return 'homeworks';
            }
            case 'something': {
                return 'something';
            }
            default: {
                return key;
            }
        }
    }

    public addHomework(hw: Homework): void {
        this.Homeworks.push(hw);
    }
}