using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lesson64 : MonoBehaviour
{
    // Start is called before the first frame update
    private void Start()
    {
        #region ��Ҫ֪ʶ�ع�

        //1.Ԥ����ָ��
        //  Shader��Ҳ����Ԥ����ָ��
        //  ����ͨ��ѡ�޿λع���C#�е�Ԥ����ָ��
        //  ����ʹ�ú�Shader��������

        //2.ǰ����Ⱦ·����������й��ռ���
        //  Base Pass��������Ⱦͨ������
        //  ��Ҫ���ڴ���Ӱ��������һ����������Դ��ƽ�й⣩�������У��𶥵㴦����������SH������Դ ��
        //  Additional Pass��������Ⱦͨ������
        //  ��Ҫ���ڴ���Ӱ�������ĳ�ƽ�й������������������Դ��ÿ����������Դ������ã�

        #endregion ��Ҫ֪ʶ�ع�

        #region ֪ʶ��һ ǰ����Ⱦ·����������Ҫ��ע����ʲô���ݣ�

        //����Pass
        //1.Base Pass��������Ⱦͨ����ÿ��ƬԪֻ�����һ�Σ���
        //  ֻ��Ҫ����һ��������ƽ�й�Դ��һ�㳡�����������Զ���ֵ��Ӧ������
        //  �������У��𶥵㣩����������SH����ԴUnity��������Ǵ���
        //2.Additional Pass��������Ⱦͨ����:
        //  ����������ƽ�й⡢�����������Ĺ�Դ(������ƽ�й⡢���Դ���۹��)�������һ�θ�Pass���м���

        //�������һ����Ҫ��Additional Pass���жϹ�Դ�������ֱ������߼�

        #endregion ֪ʶ��һ ǰ����Ⱦ·����������Ҫ��ע����ʲô���ݣ�

        #region ֪ʶ��� �����Shader���жϹ�Դ����

        //Unity���ṩ��������Ҫ�ĺ�
        //�ֱ��ǣ�
        //_DIRECTIONAL_LIGHT:ƽ�й�
        //_POINT_LIGHT:���Դ
        //_SPOT_LIGHT:�۹��

        //������������ã�
        //���������ڱ���ʱ���������ж����������ų���ͬ�Ĵ���飬ʵ����������

        //���ǿ���ʹ����Щ�����Unity Shader�е���������Ԥ����ָ��
        //�����ڱ���ʱ����һ��������ѡ���Եذ������ų������
        //#if defined(_DIRECTIONAL_LIGHT)
        //  ƽ�й��߼�
        //#elif defined (_POINT_LIGHT)
        //  ���Դ�߼�
        //#elif defined (_SPOT_LIGHT)
        //  �۹���߼�
        //#else
        //  �����߼�
        //#endif

        //Unity�ײ����ݸ���������ָ��
        //���ɳɶ�� Shader Variants����ɫ�����壩
        //��Щ Variants ���干����ͬ�ĺ��Ĵ���
        //���������������ѡ��������ͬ�Ĵ����

        //Shader variants �Ļ����������ڱ�д shader ʱ��
        //ͨ����������ָ�#if, #elif, #else, #endif��
        //���ݲ�ͬ������ѡ�����ɶ���汾�� shader��
        //��Щ��ͬ�汾�� shader ��Ϊ shader variants��

        #endregion ֪ʶ��� �����Shader���жϹ�Դ����
    }

    // Update is called once per frame
    private void Update()
    {
    }
}